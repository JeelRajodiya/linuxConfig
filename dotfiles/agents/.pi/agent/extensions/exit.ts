import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.registerCommand("exit", {
		description: "Exit pi",
		handler: (_args, ctx) => ctx.shutdown(),
	});
}
