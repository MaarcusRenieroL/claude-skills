---
description: Have QA add characterization tests to an untested area (do this BEFORE letting agents change it)
argument-hint: <module, folder, or feature to cover>
---

# Add Test Command

Target: $ARGUMENTS

1. Use `explorer` to find the code, its entry points, and any existing tests and
   test setup. If there is no test runner configured, stop and propose the smallest
   standard setup for this stack (Vitest/Jest, JUnit 5 + Testcontainers, etc.) and
   wait for my approval, since it adds dependencies.
2. Use the `qa` agent to write characterization tests that pin the CURRENT
   behavior of the target, covering the main paths and the obvious edge cases. Tests
   describe what the code does today, even where that looks wrong; list suspicious
   behavior separately instead of asserting it as correct.
3. Run `${CLAUDE_PLUGIN_ROOT}/scripts/gates.sh`. All new tests must pass.
4. Report: tests added, what they cover, what they do not cover, suspicious
   behavior found.
