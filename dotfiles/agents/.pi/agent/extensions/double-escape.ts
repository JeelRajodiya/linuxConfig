import {
	CustomEditor,
	type ExtensionAPI,
	type KeybindingsManager,
} from "@earendil-works/pi-coding-agent";
import { matchesKey, type EditorTheme, type TUI } from "@earendil-works/pi-tui";

const INTERRUPT_WINDOW_MS = 5_000;

class DoubleEscapeEditor extends CustomEditor {
	constructor(
		tui: TUI,
		theme: EditorTheme,
		keybindings: KeybindingsManager,
		private readonly handleEscape: () => boolean,
	) {
		super(tui, theme, keybindings);
	}

	override handleInput(data: string): void {
		if (matchesKey(data, "escape") && this.handleEscape()) return;
		super.handleInput(data);
	}
}

export default function (pi: ExtensionAPI) {
	let presses = 0;
	let resetTimer: ReturnType<typeof setTimeout> | undefined;
	let resetWorkingMessage: (() => void) | undefined;

	const reset = () => {
		presses = 0;
		if (resetTimer) clearTimeout(resetTimer);
		resetTimer = undefined;
		resetWorkingMessage?.();
	};

	pi.on("session_start", (_event, ctx) => {
		if (ctx.mode !== "tui") return;
		resetWorkingMessage = () => ctx.ui.setWorkingMessage();

		ctx.ui.setEditorComponent((tui, theme, keybindings) =>
			new DoubleEscapeEditor(tui, theme, keybindings, () => {
				if (ctx.isIdle()) return false;

				presses++;
				if (presses >= 2) {
					reset();
					return false;
				}

				ctx.ui.setWorkingMessage("esc again to interrupt");
				resetTimer = setTimeout(reset, INTERRUPT_WINDOW_MS);
				return true;
			}),
		);
	});

	pi.on("agent_settled", reset);
	pi.on("session_shutdown", reset);
}
