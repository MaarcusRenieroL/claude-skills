---
description: Explain a file, function, error, or concept from scratch, line by line, in beginner terms.
argument-hint: <file, function, error message, or concept>
---

# Explain Command

Target: $ARGUMENTS

Load `programming-foundations`. Explain as if to a beginner who knows no jargon.

1. Read the target (use the `explorer` agent for large areas). If it is an error
   message, read it completely and say what each part means.
2. Give: **what it does in one sentence**, then a walk-through in order, defining
   each new term the first time it appears. Use a real-world analogy only if it
   genuinely helps.
3. Where it relates to Java (or Angular), compare to what I likely already know.
4. Point out anything in it that is wrong, risky, or confusing, plainly.
5. End with one question to check I understood, and the doc topic to read
   (look it up with Context7; never invent URLs).
6. Do not modify any files.
