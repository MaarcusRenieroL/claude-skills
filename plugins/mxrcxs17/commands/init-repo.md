---
description: Generate a lean CLAUDE.md (with a Mode line) and LEARNING.md for the current repo from its real stack and scripts
---

# Init Repo Command

Create `CLAUDE.md` in the repo root (if one exists, show me a diff instead of overwriting).

1. Ask me ONE question first: is this repo **learn** mode (I write the code, you
   coach) or **ship** mode (agents write it)? Put the answer on a `Mode:` line.
2. Use `explorer` to detect: language/framework versions, package manager,
   monorepo layout, how to run dev/lint/typecheck/test/build, the auth/ORM/API
   layer in use, folder conventions, and existing test setup.
3. Start from `${CLAUDE_PLUGIN_ROOT}/templates/CLAUDE.md.base`. Fill in only
   facts you verified in the repo. Delete any section you cannot fill truthfully.
4. Hard limit: under 80 lines. Every line is paid for on every turn, so no
   generic advice, only what is specific to this repo.
5. Add a "Do not touch" list (generated files, applied migrations, lockfiles,
   CI) and the exact gate commands.
6. If the mode is learn and `LEARNING.md` is missing, create it from
   `${CLAUDE_PLUGIN_ROOT}/templates/LEARNING.md.base`.
7. Show me the result and flag anything you inferred rather than verified.
