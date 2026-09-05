import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const STATE_TYPE = "openai-fast";

function isRecord(value: unknown): value is Record<string, unknown> {
	return typeof value === "object" && value !== null && !Array.isArray(value);
}

export default function openAICodexFast(pi: ExtensionAPI) {
	let enabled = false;

	pi.on("session_start", (_event, ctx) => {
		enabled = false;
		for (const entry of ctx.sessionManager.getEntries()) {
			if (entry.type === "custom" && entry.customType === STATE_TYPE && isRecord(entry.data)) {
				enabled = entry.data.enabled === true;
			}
		}
	});

	pi.registerCommand("fast", {
		description: "Toggle OpenAI priority mode for this session (default: off); /fast [on|off]",
		handler: async (args, ctx) => {
			const value = args.trim().toLowerCase();
			if (value && value !== "on" && value !== "off") {
				ctx.ui.notify("Usage: /fast [on|off]", "warning");
				return;
			}
			enabled = value ? value === "on" : !enabled;
			pi.appendEntry(STATE_TYPE, { enabled });
			pi.events.emit("openai-fast:changed", { enabled });
			ctx.ui.notify(
				enabled ? "OpenAI fast mode ON — priority requested; may use more allowance."
					: "OpenAI fast mode OFF — standard processing.",
				"info",
			);
		},
	});

	pi.on("before_provider_request", (event, ctx) => {
		const model = ctx.model;
		if (
			!model ||
			(model.provider !== "openai-codex" && model.provider !== "openai") ||
			!isRecord(event.payload) ||
			event.payload.model !== model.id
		) {
			return;
		}

		return {
			...event.payload,
			service_tier: enabled ? "priority" : "default",
		};
	});
}
