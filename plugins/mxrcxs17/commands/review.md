---
description: Run the reviewer agent on the current branch diff (the end-of-task check). Mentor-style in learn mode.
argument-hint: [base-branch, defaults to main]
---

# Review Command

1. Read `Mode:` in `CLAUDE.md` and pass it to the reviewer (`learn`, `ship`; ask
   if missing).
2. Run `${CLAUDE_PLUGIN_ROOT}/scripts/gates.sh` and keep the output.
3. Use the `reviewer` agent. Give it: the mode, the base branch ($ARGUMENTS, or
   `main` if empty), the gate output, and the instruction to review
   `git diff <base>...HEAD` plus uncommitted changes.
4. Show me its output exactly as returned. In ship mode that is the verdict and
   "HUMAN MUST LOOK AT" list. In learn mode it is Socratic questions first, then
   ranked findings; I answer the questions before you reveal the answers.
5. Then add one line: whether gates passed, and whether I should merge now or
   look at the listed items first.
