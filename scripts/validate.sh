#!/usr/bin/env bash
# Validates the repo: JSON parses, markdown frontmatter present, scripts have valid syntax.
set -u
cd "$(dirname "$0")/.." || exit 1
bad=0
err() { echo "ERROR: $*"; bad=$((bad + 1)); }

for f in .claude-plugin/marketplace.json plugins/mxrcxs17/.claude-plugin/plugin.json plugins/mxrcxs17/.mcp.json plugins/mxrcxs17/hooks/hooks.json plugins/mxrcxs17/templates/mcp/*.json; do
  node -e 'JSON.parse(require("fs").readFileSync(process.argv[1],"utf8"))' "$f" 2>/dev/null || err "invalid JSON: $f"
done

fm() { # frontmatter must open on line 1 and contain the given keys
  local f="$1"; shift
  [ "$(head -n1 "$f")" = "---" ] || { err "no frontmatter: $f"; return; }
  local block; block="$(awk 'NR>1 && /^---$/{exit} NR>1{print}' "$f")"
  for k in "$@"; do echo "$block" | grep -q "^$k:" || err "missing '$k' in $f"; done
}
for f in plugins/mxrcxs17/agents/*.md;   do fm "$f" name description tools model; done
for f in plugins/mxrcxs17/commands/*.md; do fm "$f" description; done
for f in plugins/mxrcxs17/skills/*/SKILL.md; do
  fm "$f" name description
  want="$(basename "$(dirname "$f")")"
  grep -q "^name: $want$" "$f" || err "skill name must equal folder name: $f"
done

for f in plugins/mxrcxs17/scripts/*.sh scripts/*.sh; do bash -n "$f" || err "bash syntax: $f"; done
node --check plugins/mxrcxs17/hooks/protect-files.mjs || err "node syntax: protect-files.mjs"

[ "$bad" -eq 0 ] && echo "OK: all checks passed" || { echo "$bad problem(s)"; exit 1; }
