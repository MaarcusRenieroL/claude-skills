---
description: Start a guided lesson on a topic in the current repo. You write the code; I coach with the hint ladder.
argument-hint: <topic or the next Life OS step>
---

# Learn Command

Topic: $ARGUMENTS (if empty, read `LEARNING.md` and propose the next item from **Next**).

Load the `programming-foundations` skill and follow learn mode exactly. Then:

1. Read `LEARNING.md` if it exists (create it from
   `${CLAUDE_PLUGIN_ROOT}/templates/LEARNING.md.base` if not) to calibrate level.
2. Teach the topic in this shape: one short concept paragraph, a 3-6 step plain-English
   plan, then name ONLY the first step and ask me to write it and run it.
3. Load the matching stack skill (`stack-spring`, `stack-angular`, `stack-data`, ...)
   and use its "Learn mode" section and "Capstone step" to pick the exercise.
4. Use Context7 for current docs; name doc topics, never invent URLs.
5. Do NOT write or edit my source files. Wait for me to show my code, then review
   it: Socratic question first, then ranked findings with `path:line`.
6. When the step is done, run the understanding check (2-3 questions) and update
   `LEARNING.md`.
