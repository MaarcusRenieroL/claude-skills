#!/usr/bin/env bash
# Preflight for macOS. Checks tools, validates the repo, makes scripts executable,
# and prints the two Claude Code commands to run. It does not modify ~/.claude itself.
set -u
cd "$(dirname "$0")/.." || exit 1
root="$(pwd)"

need() { command -v "$1" >/dev/null 2>&1 && echo "ok       $1" || { echo "MISSING  $1  ->  $2"; missing=1; }; }
missing=0
echo "Checking tools"
need claude "install Claude Code: https://docs.claude.com/en/docs/claude-code"
need node   "brew install node"
need git    "xcode-select --install"
need gh     "brew install gh && gh auth login"
command -v docker >/dev/null 2>&1 && echo "ok       docker" || echo "optional docker (needed for Testcontainers)"
command -v java   >/dev/null 2>&1 && echo "ok       java"   || echo "optional java (Spring repos)"

chmod +x plugins/mxrcxs17/scripts/gates.sh plugins/mxrcxs17/hooks/protect-files.mjs scripts/*.sh
echo; echo "Validating repo"
./scripts/validate.sh || exit 1

[ "$missing" -eq 1 ] && { echo; echo "Install the missing tools above, then rerun."; exit 1; }

cat <<EOF

Next, inside Claude Code run:

  /plugin marketplace add $root
  /plugin install mxrcxs17@mxrcxs17-skills

Then verify with /agents (explorer, frontend, backend, qa, reviewer should be listed),
run /mxrcxs17:gates in any repo to confirm \${CLAUDE_PLUGIN_ROOT} resolves,
and follow third-party/INSTALL.md.
EOF
