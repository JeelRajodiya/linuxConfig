import { readFile, readdir } from "node:fs/promises";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const sessionsDir = join(homedir(), ".pi", "agent", "sessions");

async function monthlyCost(): Promise<number> {
    const now = new Date();
    const month = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;
    let total = 0;
    for (const file of await readdir(sessionsDir, { recursive: true })) {
        if (!file.endsWith(".jsonl")) continue;
        try {
            for (const line of (await readFile(join(sessionsDir, file), "utf8")).split("\n")) {
                const entry = JSON.parse(line) as { timestamp?: string; message?: { usage?: { cost?: { total?: number } } } };
                if (entry.timestamp?.startsWith(month)) total += entry.message?.usage?.cost?.total ?? 0;
            }
        } catch { }
    }
    return total;
}

export default function (pi: ExtensionAPI) {
    const update = async (ctx: any) =>
        ctx.ui.setStatus("monthly-cost", ctx.ui.theme.fg("success", `$${(await monthlyCost()).toFixed(2)} (this month)`));

    pi.on("session_start", async (_event, ctx) => update(ctx));
    pi.on("agent_settled", async (_event, ctx) => update(ctx));
}
