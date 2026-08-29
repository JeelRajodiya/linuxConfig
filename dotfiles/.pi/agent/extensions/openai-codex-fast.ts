import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const FAST_MODELS = new Set(["gpt-5.6-terra", "gpt-5.6-luna", "gpt-5.6-sol"]);

function isRecord(value: unknown): value is Record<string, unknown> {
	return typeof value === "object" && value !== null && !Array.isArray(value);
}

export default function openAICodexFast(pi: ExtensionAPI) {
	pi.on("before_provider_request", (event, ctx) => {
		const model = ctx.model;
		if (
			!model ||
			model.provider !== "openai-codex" ||
			model.api !== "openai-codex-responses" ||
			!FAST_MODELS.has(model.id) ||
			!isRecord(event.payload) ||
			event.payload.model !== model.id ||
			"service_tier" in event.payload
		) {
			return;
		}

		return {
			...event.payload,
			service_tier: "priority",
		};
	});
}
