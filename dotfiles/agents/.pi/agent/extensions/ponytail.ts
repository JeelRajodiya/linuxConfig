import { createRequire } from "node:module";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const require = createRequire(import.meta.url);
const ponytailRoot = join(homedir(), ".pi", "agent", "npm", "node_modules", "@dietrichgebert", "ponytail");
const {
	DEFAULT_MODE,
	RUNTIME_MODES,
	getDefaultMode,
	getQuietStartup,
	getHideStatus,
	normalizeMode,
	normalizePersistedMode,
	isDeactivationCommand,
	writeDefaultMode,
} = require(join(ponytailRoot, "hooks/ponytail-config.js"));
const { getPonytailInstructions } = require(join(ponytailRoot, "hooks/ponytail-instructions.js"));

const runtimeModeList = RUNTIME_MODES.join("|");
const commandDescription = `Set mode: ${runtimeModeList}. Commands: status, default <mode>`;

export default function ponytailExtension(pi: ExtensionAPI) {
	let currentMode = DEFAULT_MODE;
	let configuredDefaultMode = getDefaultMode();
	let hideStatus = getHideStatus();
	let lastCtx: any;

	function syncStatus(ctx?: any) {
		if (ctx) lastCtx = ctx;
		const c = ctx || lastCtx;
		if (hideStatus || !c?.ui?.setStatus) return;
		let theme;
		try {
			theme = c.ui.theme;
			if (!theme?.fg) return;
		} catch {
			return;
		}
		c.ui.setStatus(
			"ponytail",
			currentMode === "off" ? "" : theme.fg("muted", "ponytail: ") + theme.fg("text", currentMode),
		);
	}

	const setMode = (mode: string, ctx?: any) => {
		const normalized = normalizePersistedMode(mode);
		if (!normalized) return;
		currentMode = normalized;
		pi.appendEntry("ponytail-mode", { mode: normalized });
		syncStatus(ctx);
		ctx?.ui?.notify?.(`Ponytail mode set to ${normalized}.`, "info");
	};

	pi.registerCommand("ponytail", {
		description: commandDescription,
		handler: async (args, ctx) => {
			const fallback = normalizePersistedMode(configuredDefaultMode) || DEFAULT_MODE;
			const [primary, secondary] = String(args || "").trim().toLowerCase().split(/\s+/);
			if (!primary) return setMode(fallback === "off" ? "full" : fallback, ctx);
			if (primary === "status") return void ctx.ui.notify(`Ponytail: current ${currentMode} • default ${configuredDefaultMode}`, "info");
			if (primary === "default") {
				const mode = normalizeMode(secondary);
				if (!mode) return void ctx.ui.notify("Unknown or unsupported /ponytail mode.", "warning");
				try {
					const written = writeDefaultMode(mode);
					if (written) configuredDefaultMode = getDefaultMode();
					ctx.ui.notify(`Default Ponytail mode set to ${configuredDefaultMode}.`, "info");
				} catch (error: any) {
					ctx.ui.notify(`Failed to save default mode: ${error.message}`, "error");
				}
				return;
			}
			const mode = normalizeMode(primary);
			if (mode) return setMode(mode, ctx);
			ctx.ui.notify("Unknown or unsupported /ponytail mode.", "warning");
		},
	});

	pi.on("input", async (event) => {
		if (event?.source !== "extension" && currentMode !== "off" && isDeactivationCommand(String(event?.text || ""))) setMode("off");
	});
	pi.on("session_start", async (_event, ctx) => {
		const entries = ctx.sessionManager.getBranch?.() || ctx.sessionManager.getEntries?.() || [];
		configuredDefaultMode = getDefaultMode();
		hideStatus = getHideStatus();
		currentMode = [...entries].reverse().find((entry: any) => entry?.type === "custom" && entry?.customType === "ponytail-mode")?.data?.mode || configuredDefaultMode;
		syncStatus(ctx);
		if (!getQuietStartup()) ctx.ui.notify(`Ponytail loaded: ${currentMode}`, "info");
	});
	pi.on("agent_start", async (_event, ctx) => syncStatus(ctx));
	pi.on("agent_end", async (_event, ctx) => syncStatus(ctx));
	pi.on("before_agent_start", async (event) => {
		if (currentMode !== "off") return { systemPrompt: `${event?.systemPrompt ? `${event.systemPrompt}\n\n` : ""}${getPonytailInstructions(currentMode)}` };
	});
}
