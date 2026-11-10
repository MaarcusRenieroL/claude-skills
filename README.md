# claude-skills

My Claude Code setup as one private plugin marketplace. **Default mode is learn:** I write the code, the AI coaches me. **Ship mode is opt-in:** agents build, gates and review check them (used for Zentro).

**Goal:** learn to code properly (Java, Angular first) by rebuilding Life OS myself, while keeping an agent team available for projects where I just need things shipped.

## What's inside

```
.claude-plugin/marketplace.json     marketplace "mxrcxs17-skills"
plugins/mxrcxs17/                   plugin "mxrcxs17"
├── skills/      programming-foundations (the mentor rules)  stack-spring  stack-angular
│                stack-web-ts (React/Next)  stack-data  stack-testing  stack-node-api
│                stack-infra  stack-rust-tauri  ai-ml-common  security-checklist
├── commands/    LEARN: /mxrcxs17:learn  :explain  :quiz  :stuck
│                SHIP:  /mxrcxs17:build   (architect workflow)
│                BOTH:  :review  :gates  :add-tests  :init-repo
├── agents/      explorer (haiku) · qa (sonnet) · reviewer (opus, learn + ship output)
│                frontend · backend (sonnet, SHIP MODE ONLY)
├── hooks/       protect-files (blocks edits to .env, lockfiles, migrations, CI, keys)
├── scripts/     gates.sh (lint + typecheck + test, compact output)
├── templates/   CLAUDE.md.base (has the Mode line), LEARNING.md.base, mcp/playwright.mcp.json
└── .mcp.json    Context7 (loads in every project; skills use it for current docs)
third-party/INSTALL.md              what to install from other people's repos, and what to skip
scripts/install.sh · validate.sh
```

## Install (macOS)

```bash
cd ~/Desktop/projects/claude-skills
./scripts/install.sh          # checks tools, validates files, prints the two commands below
```
Then inside Claude Code:
```
/plugin marketplace add ~/Desktop/projects/claude-skills
/plugin install mxrcxs17@mxrcxs17-skills
```
After editing files, reinstall or restart so changes load. Then do `third-party/INSTALL.md`.

## The two modes

| | Learn (default) | Ship |
|---|---|---|
| Who types the code | **Me** | Agents (`/mxrcxs17:build`) |
| AI role | Mentor: concept, plan, hints, review, quiz | Architect + implementers + QA + reviewer |
| Used for | Life OS, portfolio, anything I want to learn | Zentro |
| Set by | `Mode:` line in the repo's `CLAUDE.md`; if missing, the AI asks | same |

Say "ship it" to flip one task to ship mode, "teach me" to flip back.

### Learn mode rules (from `programming-foundations`)
- Assumes I am a beginner. Defines every term. Java first, then Angular/TypeScript.
- Never edits my source files. One small step at a time: concept, plan, "you try".
- **Hint ladder** (`/mxrcxs17:stuck` climbs one rung): question, nudge, pseudocode, tiny snippet, full solution only if I ask.
- Reviews are Socratic first, then ranked findings (MUST FIX / SHOULD FIX / NIT) with `path:line` and a doc topic to read. Brutally honest.
- After each task, a 2-3 question quiz; results go to `LEARNING.md` (Learned / Shaky / Next / Log) in that repo.
- Docs come from Context7 by topic name. No invented links.

## Per-repo setup (once per project)

1. `cd` into the repo, start Claude Code, run `/mxrcxs17:init-repo`. It asks learn or ship, writes `CLAUDE.md`, and creates `LEARNING.md` for learn repos.
2. Needs a browser check? Copy `plugins/mxrcxs17/templates/mcp/playwright.mcp.json` to the repo as `.mcp.json`. Do not load Playwright globally.
3. No tests yet? `/mxrcxs17:add-tests <area>` before letting agents change that area (ship mode), or learn testing yourself with `/mxrcxs17:learn testing`.

## Daily flow

**Learn (Life OS):** `/mxrcxs17:learn <next capstone step>` -> write it -> `/mxrcxs17:stuck` if blocked -> `/mxrcxs17:review` -> `/mxrcxs17:quiz`.

**Ship (Zentro), 15 minutes of my time:** evening `/mxrcxs17:build <task with acceptance checks>`; morning `/mxrcxs17:review`, read the **HUMAN MUST LOOK AT** list, check those items in the diff, then merge. Reviewer saying APPROVE is not permission to merge blind.

## The Life OS capstone (all-in-one project)

Each stack skill ends with a "Capstone step". Order: data model (`stack-data`) -> Spring API (`stack-spring`) -> tests first (`stack-testing`) -> Angular UI (`stack-angular`) -> auth (`security-checklist`) -> Docker/CI (`stack-infra`) -> AI feature (`ai-ml-common`). Optional later: Rust/Tauri window. Keep it personal; never mix in employer code.

## Models and the Pro plan

- Explorer on Haiku, builders and QA on Sonnet, reviewer on Opus (frontmatter). Opus once, at the end.
- Learn mode mostly runs on the main session; keep it on Sonnet.

## Rules I'm holding myself to

- Gates, not agent consensus, decide "done" in ship mode. `gates.sh` exits non-zero if nothing is detected and prints `SKIP test` when no tests exist.
- Max 12 skills active. Each description costs context every turn. Currently 11.
- No secrets in this repo. MCP tokens go in environment variables.
- Skills state no framework versions; they tell the AI to look up the installed version via Context7.
- Employer code is confidential: skills and `LEARNING.md` stay generic.
- Read every third-party SKILL.md and script before installing; install from the original author's repo.

## Known limits (honest list)

- Learn mode is enforced by prompts, not a technical lock. Nothing stops the AI from editing a file if it drifts; the `Mode:` line and the agents' mode check reduce that, they do not prevent it.
- `protect-files` only sees Edit/Write calls. A Bash command can still modify those files.
- The QA agent's "tests only" rule is a prompt rule plus a reviewer check.
- `${CLAUDE_PLUGIN_ROOT}` expansion in agent/command bodies should be verified on first run: run `/mxrcxs17:gates` in any repo.
- Skills are written from general knowledge, not generated from my repos. Fix them when they are wrong.
- Reading about code does not teach it. Write the code yourself; the quizzes exist because AI makes understanding feel easier than it is.

## Roadmap (only if needed)

Life OS MCP server (job tracker, notes) after the capstone. Not part of the masters path.
