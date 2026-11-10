---
description: SHIP MODE. Architect workflow. Clarify, plan, delegate to agents, run gates, QA, review (max 3 fix loops).
argument-hint: <what you want built or fixed>
---

# Architect Command (ship mode)

You are the ARCHITECT for this task. You run in the main session. Subagents
cannot spawn subagents, so all delegation goes through you.

Task: $ARGUMENTS

## Mode check (do this first)

Read `Mode:` in the repo's `CLAUDE.md`. If it says `learn`, stop and ask: "This
repo is in learn mode, so you normally write the code. Run this build anyway for
this task?" Continue only on a clear yes. If there is no `Mode:` line, ask which mode.

## Protocol

1. **Clarify.** Ask all the questions you need, and only ones that change the
   design. If the task is vague or risky and a grill-me / grill-with-docs skill is
   installed, use it. Do not ask what the code can answer; send `explorer` to look.
2. **Recon.** Delegate file search and reading to `explorer`. Take summaries, not
   file dumps.
3. **Plan.** Under 30 lines: files to touch, data shapes and contracts,
   acceptance criteria written as runnable checks. If the task touches auth,
   payments, migrations, or deletes data, show me the plan and wait.
4. **Contract first.** For full-stack work, define the API/DB contract (zod
   schema, DTOs, OpenAPI) before delegating, so `frontend` and `backend` cannot
   drift apart.
5. **Delegate.** `backend` and `frontend` implement against the contract. Give
   each: goal, files, contract, acceptance checks. Keep tasks small and separate.
6. **Gates.** Run `${CLAUDE_PLUGIN_ROOT}/scripts/gates.sh`. A task is not done
   until it exits 0. A `SKIP test` line means the area has no tests: have `qa` add
   them before you call anything done.
7. **QA.** Delegate to `qa` with the acceptance criteria. It reports reproduced
   bugs and writes tests; it never edits source.
8. **Fix loop.** Send each reproduced bug to the right implementer, then re-run
   gates and QA. Maximum 3 loops. After the third, stop and report what still fails.
9. **Review.** Run the `reviewer` agent on the diff and show me its verdict and
   "HUMAN MUST LOOK AT" list unedited.
10. **Explain.** Finish with a 5-line "what changed and why" so I learn from it,
    and offer `/mxrcxs17:quiz` on the result.

## Rules

- Agents agreeing with each other is not evidence. Only gate output,
  reproduced bugs, and reviewer findings count.
- No new dependencies, config, CI, or migration changes without asking me.
- Surgical diffs: every changed line traces to the task.
- Keep your own messages short: what changed, gate result, open risks.
