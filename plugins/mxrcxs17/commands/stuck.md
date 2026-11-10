---
description: I'm stuck. Climb exactly one rung of the hint ladder for the current problem.
argument-hint: [what you are stuck on]
---

# Stuck Command

Problem: $ARGUMENTS (if empty, use the problem we were just working on).

Load `programming-foundations`. Track which rung we are on in this conversation:

1. Question -> 2. Nudge (concept/doc topic) -> 3. Pseudocode -> 4. Tiny snippet
(max ~5 lines) -> 5. Full solution.

Give EXACTLY the next rung above the last one you gave, not higher. If this is
the first call, start at rung 1. Before climbing, run the code/tests and read the
actual error so the hint is based on facts.

Only give rung 5 if I say "show me" or the previous rung-4 hint failed, and then
explain it line by line and ask me to retype it from memory afterwards. Say which
rung you just gave so I can ask for the next. Do not edit my files.
