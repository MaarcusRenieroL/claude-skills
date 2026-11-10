---
description: Run lint, typecheck and tests for this repo (add --full for the build)
argument-hint: [--full]
---

# Gates Command

Run `${CLAUDE_PLUGIN_ROOT}/scripts/gates.sh $ARGUMENTS` from the repo root.

Report only: each PASS/FAIL/SKIP line, and for failures the cause in one sentence.
If a gate says SKIP because there is no test script, say that plainly; it is not
a pass. Do not fix anything unless I ask.
