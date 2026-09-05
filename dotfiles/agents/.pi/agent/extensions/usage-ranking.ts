import {
	DynamicBorder,
	getAgentDir,
	type ExtensionAPI,
	type ExtensionContext,
	type KeybindingsManager,
	type Theme,
} from "@earendil-works/pi-coding-agent";
import type { Model } from "@earendil-works/pi-ai";
import {
	Container,
	fuzzyFilter,
	Input,
	matchesKey,
	Spacer,
	Text,
	truncateToWidth,
	type AutocompleteItem,
	type Component,
	type Focusable,
	type TUI,
} from "@earendil-works/pi-tui";
import { appendFileSync, mkdirSync, readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { readFile, readdir } from "node:fs/promises";

const usageFile = join(getAgentDir(), "usage-ranking.jsonl");
const monthlyModelUsage = new Map<string, number>();
const commandUsage = new Map<string, number>();

const increment = (counts: Map<string, number>, key: string, amount = 1) =>
	counts.set(key, (counts.get(key) ?? 0) + amount);

const modelKey = (model: Pick<Model<any>, "provider" | "id">) => `${model.provider}/${model.id}`;

function loadUsage() {
	mkdirSync(getAgentDir(), { recursive: true });
	try {
		for (const line of readFileSync(usageFile, "utf8").split("\n")) {
			if (!line) continue;
			const event = JSON.parse(line);
			if (event.type === "command") increment(commandUsage, event.key);
		}
	} catch {}
}

function recordCommand(key: string) {
	increment(commandUsage, key);
	// ponytail: append-only avoids cross-process lost updates; compact if this reaches megabytes.
	appendFileSync(usageFile, `${JSON.stringify({ type: "command", key })}\n`);
}

function rank<T>(items: T[], counts: Map<string, number>, key: (item: T) => string): T[] {
	return items
		.map((item, index) => ({ item, index }))
		.sort((a, b) =>
			(counts.get(key(b.item)) ?? 0) - (counts.get(key(a.item)) ?? 0) || a.index - b.index,
		)
		.map(({ item }) => item);
}

function isInMonths(timestamp: unknown, months = 1, now = new Date()): boolean {
	if (typeof timestamp !== "string") return false;
	const date = new Date(timestamp);
	const age = (now.getFullYear() - date.getFullYear()) * 12 + now.getMonth() - date.getMonth();
	return age >= 0 && age < months;
}

function scanSession(lines: string[], counts?: Map<string, number>, costs?: Map<string, number>, requests?: Map<string, number>, months = 1, now = new Date()) {
	let activeModel: string | undefined;
	for (const line of lines) {
		try {
			const entry = JSON.parse(line);
			if (entry.type === "model_change" && typeof entry.provider === "string" && typeof entry.modelId === "string")
				activeModel = `${entry.provider}/${entry.modelId}`;
			if (!isInMonths(entry.timestamp, months, now) || entry.type !== "message") continue;
			const message = entry.message;
			if (counts && message?.role === "user" && activeModel) increment(counts, activeModel);
			if (requests && message?.role === "assistant" && typeof message.provider === "string" && typeof message.model === "string")
				increment(requests, `${message.provider}/${message.model}`);
			const cost = message?.usage?.cost?.total;
			if (costs && message?.role === "assistant" && typeof message.provider === "string" &&
				typeof message.model === "string" && typeof cost === "number" && Number.isFinite(cost) && cost >= 0)
				increment(costs, `${message.provider}/${message.model}`, cost);
		} catch {}
	}
}

function loadMonthlyUsage() {
	const sessionsDir = join(getAgentDir(), "sessions");
	try {
		for (const entry of readdirSync(sessionsDir, { recursive: true, withFileTypes: true })) {
			if (entry.isFile() && entry.name.endsWith(".jsonl"))
				scanSession(readFileSync(join(entry.parentPath, entry.name), "utf8").split("\n"), monthlyModelUsage);
		}
	} catch {}
}

async function loadMonthlyStats() {
	const counts = new Map<string, number>();
	const requests = new Map<string, number>();
	const costs = new Map<string, number>();
	const ratioCounts = new Map<string, number>();
	const ratioRequests = new Map<string, number>();
	const now = new Date();
	const sessionsDir = join(getAgentDir(), "sessions");
	for (const file of await readdir(sessionsDir, { recursive: true })) {
		if (!file.endsWith(".jsonl")) continue;
		const lines = (await readFile(join(sessionsDir, file), "utf8")).split("\n");
		scanSession(lines, counts, costs, requests, 1, now);
		scanSession(lines, ratioCounts, undefined, ratioRequests, 2, now);
	}
	return { counts, costs, requests, ratioCounts, ratioRequests };
}

function requestsPerMessage(requests: number, messages: number): string {
	return messages > 0 ? `${(requests / messages).toFixed(1)} req/msg` : "req/msg n/a";
}

class ModelPicker implements Component, Focusable {
	private readonly input = new Input();
	private readonly container = new Container();
	private filtered: Model<any>[] = [];
	private selected = 0;
	private _focused = false;

	get focused() { return this._focused; }
	set focused(value: boolean) { this._focused = value; this.input.focused = value; }

	constructor(
		private readonly models: Model<any>[],
		private readonly stats: Awaited<ReturnType<typeof loadMonthlyStats>>,
		private readonly tui: TUI,
		private readonly theme: Theme,
		private readonly keybindings: KeybindingsManager,
		private readonly done: (model?: Model<any>) => void,
		initialQuery = "",
	) {
		this.input.setValue(initialQuery);
		this.update();
	}

	private update() {
		const query = this.input.getValue();
		const matches = query
			? fuzzyFilter(this.models, query, model => `${model.provider} ${model.id} ${model.name}`)
			: this.models;
		this.filtered = rank<Model<any>>(matches, this.stats.counts, modelKey);
		this.selected = Math.min(this.selected, Math.max(0, this.filtered.length - 1));
		this.container.clear();
		this.container.addChild(new DynamicBorder((text: string) => this.theme.fg("accent", text)));
		this.container.addChild(new Text(this.theme.fg("accent", this.theme.bold("Select model · this month")), 1, 0));
		this.container.addChild(this.input);
		this.container.addChild(new Spacer(1));
		const start = Math.max(0, Math.min(this.selected - 5, this.filtered.length - 10));
		for (let index = start; index < Math.min(start + 10, this.filtered.length); index++) {
			const model = this.filtered[index]!;
			const key = modelKey(model);
			const prefix = index === this.selected ? "→ " : "  ";
			const count = this.stats.counts.get(key) ?? 0;
			const requests = this.stats.requests.get(key) ?? 0;
			const cost = this.stats.costs.get(key);
			const text = `${prefix}${key} · ${count} msg · ${requests} req · ${requestsPerMessage(this.stats.ratioRequests.get(key) ?? 0, this.stats.ratioCounts.get(key) ?? 0)} (2mo) · ${cost === undefined ? "cost n/a" : `$${cost.toFixed(2)} est.`} · $${model.cost.output}/1M output`;
			this.container.addChild(new Text(index === this.selected ? this.theme.fg("accent", text) : text, 0, 0));
		}
		if (!this.filtered.length) this.container.addChild(new Text(this.theme.fg("muted", "  No matching models"), 0, 0));
		this.container.addChild(new Spacer(1));
		this.container.addChild(new Text(this.theme.fg("dim", "↑↓ navigate · enter select · esc cancel"), 1, 0));
		this.container.addChild(new DynamicBorder((text: string) => this.theme.fg("accent", text)));
	}

	handleInput(data: string) {
		if (this.keybindings.matches(data, "tui.select.up")) {
			this.selected = this.filtered.length ? (this.selected - 1 + this.filtered.length) % this.filtered.length : 0;
		} else if (this.keybindings.matches(data, "tui.select.down")) {
			this.selected = this.filtered.length ? (this.selected + 1) % this.filtered.length : 0;
		} else if (this.keybindings.matches(data, "tui.select.confirm")) {
			this.done(this.filtered[this.selected]);
			return;
		} else if (this.keybindings.matches(data, "tui.select.cancel")) {
			this.done();
			return;
		} else {
			this.input.handleInput(data);
			this.selected = 0;
		}
		this.update();
		this.tui.requestRender();
	}

	render(width: number) { return this.container.render(width).map(line => truncateToWidth(line, width, "")); }
	invalidate() { this.container.invalidate(); }
}

function completedModelQuery(submitting: boolean, lines: string[]): string | undefined {
	if (!submitting) return;
	const match = lines.join("\n").trim().match(/^\/model(?:\s+(.*))?$/);
	return match ? match[1] ?? "" : undefined;
}

loadUsage();
loadMonthlyUsage();

if (process.env.PI_USAGE_RANK_SELF_TEST) {
	const now = new Date(2026, 0, 15);
	for (const [timestamp, monthly, twoMonths] of [
		[new Date(2026, 0, 1).toISOString(), true, true],
		[new Date(2025, 11, 1).toISOString(), false, true],
		[new Date(2025, 10, 30).toISOString(), false, false],
		[new Date(2026, 1, 1).toISOString(), false, false],
		["invalid", false, false],
	] as const) {
		if (isInMonths(timestamp, 1, now) !== monthly || isInMonths(timestamp, 2, now) !== twoMonths) throw new Error("Month window failed");
	}
	const messages = new Map<string, number>();
	const requests = new Map<string, number>();
	const costs = new Map<string, number>();
	const timestamp = new Date().toISOString();
	scanSession([
		JSON.stringify({ type: "model_change", provider: "test", modelId: "sol" }),
		JSON.stringify({ type: "message", timestamp, message: { role: "user" } }),
		JSON.stringify({ type: "message", timestamp, message: { role: "assistant", provider: "test", model: "sol", usage: { cost: { total: 1.75 } } } }),
		JSON.stringify({ type: "message", timestamp: "2000-01-01T00:00:00Z", message: { role: "user" } }),
		JSON.stringify({ type: "message", timestamp, message: { role: "assistant", provider: "test", model: "sol" } }),
		JSON.stringify({ type: "message", timestamp, message: { role: "toolResult" } }),
		JSON.stringify({ type: "message", timestamp: "2000-01-01T00:00:00Z", message: { role: "assistant", provider: "test", model: "sol" } }),
	], messages, costs, requests);
	if (messages.get("test/sol") !== 1 || requests.get("test/sol") !== 2 || costs.get("test/sol") !== 1.75) throw new Error("Monthly model aggregation failed");
	if (requestsPerMessage(5, 2) !== "2.5 req/msg" || requestsPerMessage(0, 1) !== "0.0 req/msg" || requestsPerMessage(5, 0) !== "req/msg n/a") throw new Error("Request/message ratio failed");
	const counts = new Map([["b", 2], ["c", 1]]);
	console.assert(rank(["a", "b", "c"], counts, value => value).join("") === "bca");
	for (const [submit, lines, expected] of [
		[true, ["/model "], ""],
		[true, ["/model sol"], "sol"],
		[false, ["/model "], undefined],
		[true, ["/models"], undefined],
	] as const) {
		if (completedModelQuery(submit, [...lines]) !== expected) throw new Error("Model completion routing failed");
	}
}

export default function (pi: ExtensionAPI) {
	let sessionGeneration = 0;
	pi.on("session_shutdown", () => { sessionGeneration++; });
	let pickerOpen = false;
	const showPicker = async (ctx: ExtensionContext, query = "") => {
		if (pickerOpen || ctx.mode !== "tui") return;
		pickerOpen = true;
		const generation = sessionGeneration;
		ctx.ui.setEditorText("");
		try {
			const stats = await loadMonthlyStats();
			if (generation !== sessionGeneration) return;
			const model = await ctx.ui.custom<Model<any> | undefined>((tui, theme, keybindings, done) =>
				new ModelPicker(ctx.modelRegistry.getAvailable(), stats, tui, theme, keybindings, done, query),
			);
			if (generation !== sessionGeneration) return;
			if (model && !await pi.setModel(model) && generation === sessionGeneration) ctx.ui.notify(`No authentication for ${modelKey(model)}`, "error");
		} catch (error) {
			if (generation === sessionGeneration) ctx.ui.notify(`Model picker: ${String(error)}`, "error");
		} finally {
			pickerOpen = false;
		}
	};

	const cycleModel = async (ctx: ExtensionContext, direction: 1 | -1) => {
		const models = rank<Model<any>>(ctx.modelRegistry.getAvailable(), monthlyModelUsage, modelKey);
		if (!ctx.model || models.length < 2) return;
		const current = models.findIndex(model => modelKey(model) === modelKey(ctx.model!));
		const next = models[(current + direction + models.length) % models.length];
		if (next && !await pi.setModel(next)) ctx.ui.notify(`No authentication for ${modelKey(next)}`, "error");
	};

	pi.registerShortcut("ctrl+p", {
		description: "Cycle usage-ranked models forward",
		handler: ctx => cycleModel(ctx, 1),
	});
	pi.registerShortcut("shift+ctrl+p", {
		description: "Cycle usage-ranked models backward",
		handler: ctx => cycleModel(ctx, -1),
	});

	pi.on("before_agent_start", (_event, ctx) => {
		if (ctx.model) increment(monthlyModelUsage, modelKey(ctx.model));
	});

	pi.on("session_start", (_event, ctx) => {
		sessionGeneration++;
		if (ctx.mode !== "tui") return;
		const knownCommands = new Set(pi.getCommands().map(command => command.name));
		let submitting = false;

		ctx.ui.addAutocompleteProvider(current => ({
			triggerCharacters: current.triggerCharacters,
			async getSuggestions(lines, line, col, options) {
				const result = await current.getSuggestions(lines, line, col, options);
				if (!result) return result;
				const beforeCursor = (lines[line] ?? "").slice(0, col);
				if (/^\/[^ ]*$/.test(beforeCursor)) {
					for (const item of result.items) knownCommands.add(item.value);
					result.items = rank(result.items, commandUsage, item => item.value);
				} else if (beforeCursor.startsWith("/model ")) {
					result.items = rank(result.items, monthlyModelUsage, item => item.value);
				}
				return result;
			},
			applyCompletion: (lines, line, col, item: AutocompleteItem, prefix) => {
				const result = current.applyCompletion(lines, line, col, item, prefix);
				const query = completedModelQuery(submitting, result.lines);
				if (query !== undefined) {
					const generation = sessionGeneration;
					queueMicrotask(() => {
						if (generation !== sessionGeneration) return;
						recordCommand("model");
						showPicker(ctx, query);
					});
					return { lines: [""], cursorLine: 0, cursorCol: 0 };
				}
				return result;
			},
			shouldTriggerFileCompletion: (lines, line, col) =>
				current.shouldTriggerFileCompletion?.(lines, line, col) ?? true,
		}));

		ctx.ui.onTerminalInput(data => {
			submitting = matchesKey(data, "enter");
			if (!submitting || pickerOpen) return;
			const text = ctx.ui.getEditorText().trim();
			const match = text.match(/^\/([^\s]+)(?:\s+(.*))?$/);
			if (!match) return;
			const [, command, args = ""] = match;

			if (command === "model" && (!args || !ctx.modelRegistry.getAvailable().some(model => modelKey(model) === args))) {
				recordCommand(command);
				showPicker(ctx, args);
				return { consume: true };
			}

			const generation = sessionGeneration;
			queueMicrotask(() => {
				if (generation !== sessionGeneration) return;
				if (knownCommands.has(command) && ctx.ui.getEditorText().trim() !== text) recordCommand(command);
			});
		});
	});
}
