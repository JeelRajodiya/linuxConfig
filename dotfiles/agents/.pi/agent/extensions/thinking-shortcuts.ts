import type { ThinkingLevel } from "@earendil-works/pi-agent-core";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { matchesKey } from "@earendil-works/pi-tui";

const LEVELS: ThinkingLevel[] = ["off", "minimal", "low", "medium", "high", "xhigh", "max"];

export default function (pi: ExtensionAPI) {
	const changeThinking = (direction: -1 | 1) => {
		const current = pi.getThinkingLevel();
		let index = LEVELS.indexOf(current) + direction;

		while (LEVELS[index]) {
			pi.setThinkingLevel(LEVELS[index]);
			if (pi.getThinkingLevel() !== current) return;
			index += direction;
		}
	};

	pi.on("session_start", (_event, ctx) => {
		if (ctx.mode !== "tui") return;

		ctx.ui.onTerminalInput((data) => {
			if (matchesKey(data, "shift+up")) {
				changeThinking(1);
				return { consume: true };
			}
			if (matchesKey(data, "shift+down")) {
				changeThinking(-1);
				return { consume: true };
			}
		});
	});
}
