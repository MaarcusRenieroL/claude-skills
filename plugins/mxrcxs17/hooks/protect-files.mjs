#!/usr/bin/env node
// PreToolUse hook. Blocks Edit/Write/MultiEdit on files an agent should not hand-edit.
// Exit code 2 = block; stderr is shown to Claude. Override per session: CLAUDE_ALLOW_PROTECTED=1
// Limit: this only sees Edit/Write tool calls. A Bash command (sed, echo >) can still touch these files.
import { readFileSync } from "node:fs";

let input = {};
try {
  input = JSON.parse(readFileSync(0, "utf8"));
} catch {
  process.exit(0); // unreadable input: do not break the session
}

const path = String(input?.tool_input?.file_path ?? "");
if (!path || process.env.CLAUDE_ALLOW_PROTECTED === "1") process.exit(0);

const base = path.split("/").pop() ?? "";

const checks = [
  [
    "env file (secrets)",
    () => /^\.env(\..+)?$/.test(base) && !/\.(example|sample|template)$/.test(base),
  ],
  [
    "lockfile (change deps via the package manager, not by hand)",
    () => /^(package-lock\.json|pnpm-lock\.yaml|yarn\.lock|bun\.lockb?|Cargo\.lock)$/.test(base),
  ],
  [
    "existing DB migration (generate a new one with the tool instead)",
    () => /(^|\/)(prisma\/migrations|drizzle|db\/migration|migrations?)\//.test(path),
  ],
  ["CI workflow (ask the user; CI minutes are limited)", () => /(^|\/)\.github\/workflows\//.test(path)],
  [
    "key or credential file",
    () => /\.(pem|key|p12|pfx)$/.test(base) || /^(id_rsa|id_ed25519|credentials\.json)$/.test(base),
  ],
];

for (const [reason, test] of checks) {
  if (test()) {
    console.error(
      `BLOCKED: ${reason}: ${path}\nAsk the user first. If they approve, they can relaunch with CLAUDE_ALLOW_PROTECTED=1.`,
    );
    process.exit(2);
  }
}
process.exit(0);
