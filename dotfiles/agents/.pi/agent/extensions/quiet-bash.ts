import {
    createBashToolDefinition,
    type ExtensionAPI,
    keyHint,
} from "@earendil-works/pi-coding-agent";
import { Text } from "@earendil-works/pi-tui";

const seconds = (ms: number) => `${(ms / 1000).toFixed(1)}s`;

export default function (pi: ExtensionAPI) {
    const bash = createBashToolDefinition(process.cwd());

    pi.registerTool({
        ...bash,
        renderResult(result, { expanded, isPartial }, theme, context) {
            const state = context.state as {
                startedAt?: number;
                endedAt?: number;
                interval?: NodeJS.Timeout;
            };

            if (context.executionStarted && state.startedAt === undefined) state.startedAt = Date.now();
            if (isPartial && !state.interval) {
                state.interval = setInterval(() => context.invalidate(), 1000);
            }
            if (!isPartial || context.isError) {
                state.endedAt ??= Date.now();
                if (state.interval) clearInterval(state.interval);
                state.interval = undefined;
            }

            const elapsed = state.startedAt === undefined ? "" : ` ${seconds((state.endedAt ?? Date.now()) - state.startedAt)}`;
            if (isPartial) return new Text(theme.fg("warning", `Running…${elapsed}`), 0, 0);

            const output = result.content
                .filter((content) => content.type === "text")
                .map((content) => content.text)
                .join("\n");
            let text = context.isError
                ? theme.fg("error", output)
                : theme.fg("success", `Done in${elapsed}`);

            if (!context.isError && expanded && output) {
                text += `\n${theme.fg("toolOutput", output)}`;
            } else if (!context.isError && output) {
                text += theme.fg("muted", ` (${keyHint("app.tools.expand", "show output")})`);
            }
            return new Text(text, 0, 0);
        },
    });
}
