---
description: Quiz me on what I just built or on a topic, grade honestly, and update LEARNING.md.
argument-hint: [topic, defaults to the most recent work]
---

# Quiz Command

Topic: $ARGUMENTS (default: the code changed in the latest commits or this session;
check `git diff` / `git log` and `LEARNING.md`).

Load `programming-foundations`.

1. Ask 3 questions, ONE at a time, waiting for my answer each time:
   - predict the output of a small snippet from my code,
   - what breaks if X is removed or changed,
   - why did we choose Y over Z.
2. Grade each answer honestly: correct, partly, wrong. If wrong, explain briefly
   and give a follow-up question instead of just the answer.
3. Update `LEARNING.md`: move solid topics to **Learned**, weak ones to **Shaky**,
   set **Next**, add a **Log** line.
4. If I missed two or more, propose a re-teach with `/learn` before moving on.
5. Do not modify source files.
