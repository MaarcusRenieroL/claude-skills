# Third-party skills: what to install, what to skip

Researched 2026-11-10 from the repos' own READMEs. Skills are prompts plus sometimes scripts: **read each SKILL.md (and any `scripts/`) before installing.** Install only from the original author's repo; forks and mirrors of these projects are everywhere.

Context rule: each installed skill's description sits in context every turn. Cherry-pick. Do not install whole bundles.

## Install these

### 1. Karpathy guidelines (always-on, tiny)
Repo: `github.com/multica-ai/andrej-karpathy-skills` (MIT). One `CLAUDE.md` with four principles: think before coding, simplicity first, surgical changes, goal-driven execution.
Its README's install commands reference a different owner (`forrestchang/...`), so skip the plugin command. Read the file, then paste it into your user-level `~/.claude/CLAUDE.md` once. `templates/CLAUDE.md.base` already carries a short paraphrase for per-repo use.

### 2. Matt Pocock skills
Repo: `github.com/mattpocock/skills` (MIT, ~25 skills). The plugin command installs everything, which is too much. Use the picker instead:
```bash
npx skills@latest add mattpocock/skills      # choose skills in the list
```
Pick: `setup-matt-pocock-skills` (required by the others; run `/setup-matt-pocock-skills` once per repo), `grill-with-docs` (requirements interrogation, your "grill me"), `grill-me` (non-code planning), `tdd`, `diagnosing-bugs`, `code-review`, `handoff`.
Skip for now: the issue-tracker / ticket / wayfinder / implement-spec family (heavy process, and they assume an issue-tracker workflow you aren't running).
Overlap note: his `code-review` and our `reviewer` agent both exist. Use `/mxrcxs17:review` as the gate; use his as a second opinion on big changes.

### 3. Design: Impeccable (primary)
Repo: `github.com/pbakaus/impeccable` (Apache 2.0). Commands like `/impeccable init`, `audit`, `critique`, `polish`. It builds on Anthropic's `frontend-design` skill, so **do not install both**.
```
/plugin marketplace add pbakaus/impeccable
```
Then `/plugin` to browse and install. Run `/impeccable init` once per frontend repo.

### 4. Design: Taste Skill (portfolio only)
Repo: `github.com/Leonxlnx/taste-skill` (MIT). Opinionated anti-"AI-slop" rules with dials for variance, motion, density.
```bash
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"
```
Two design skills on one page fight each other. Use this only in the portfolio repo, and not alongside Impeccable there; pick one per repo.

### 5. Anthropic's official examples (optional)
Repo: `github.com/anthropics/skills`.
```
/plugin marketplace add anthropics/skills
/plugin install example-skills@anthropic-agent-skills
```
Worth browsing for the web-app-testing and MCP-builder examples. Skip its `frontend-design` if you use Impeccable. Skip the document skills (docx/pdf/pptx/xlsx) unless you need them in Claude Code.

## Cherry-pick only: pstack
Repo: `github.com/backnotprop/pstack` (MIT; written for Cursor, mirrored for other agents). Its main entry, `poteto-mode`, pulls in around 25 other skills and defaults to a multi-model panel that assumes other vendors' models. Do not install it whole.
```bash
npx skills add backnotprop/pstack            # choose individually
```
Candidates (read them first; I have not read their SKILL.md files): `typescript-best-practices`, `correct` (turns repeated corrections into enforceable rules, useful after a few weeks), `unslop` (for your blog drafts).
Skip: `tdd` (you have Matt's), `arena`/`swarm`/`interrogate` (multi-model, token-hungry), `poteto-mode`.

## MCP servers (3 to 6 total is the sweet spot)

| Server | Scope | How | Why |
|---|---|---|---|
| Context7 | user (already in plugin `.mcp.json`) | `claude mcp add context7 --scope user -- npx -y @upstash/context7-mcp` if you ever need it outside the plugin | Current library docs; stops invented Spring/Next APIs |
| Playwright | per project | copy `templates/mcp/playwright.mcp.json` to the repo as `.mcp.json`; run `npx playwright install chromium` | QA and UI verification |
| GitHub | use `gh` CLI instead | `gh auth status` | CLI uses fewer tokens than a GitHub MCP's tool list |

Not now: Puppeteer (duplicates Playwright), Sentry (only if an app actually runs Sentry in production), Postgres/DB MCPs (add per project when a real database needs inspecting).

## Review checklist before installing anything
1. Original author's repo, license present?
2. Read `SKILL.md`: does it instruct anything beyond its stated purpose (network calls, writing outside the project, reading env files)?
3. Read every file in `scripts/`.
4. Does its description overlap a skill you already have?
5. Note the commit you reviewed. Update on purpose, not automatically.
