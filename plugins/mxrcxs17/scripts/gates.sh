#!/usr/bin/env bash
# Runs the objective gates for the repo in the current directory.
# One line per gate. Failures print only the last 40 lines (saves tokens).
# Usage: gates.sh [--full]    (--full also runs the build)
# Exit: 0 all ran gates passed | 1 a gate failed | 3 nothing detected
set -u
export CI=1   # stops test runners from entering watch mode

FULL=0
[ "${1:-}" = "--full" ] && FULL=1
fail=0
ran=0
skipped=0
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

run() { # run <name> <command...>
  local name="$1"
  shift
  ran=$((ran + 1))
  if "$@" >"$tmp/$name.log" 2>&1; then
    echo "PASS  $name"
  else
    fail=$((fail + 1))
    echo "FAIL  $name   ($*)"
    tail -n 40 "$tmp/$name.log" | sed 's/^/      /'
  fi
}

skip() { skipped=$((skipped + 1)); echo "SKIP  $1   ($2)"; }

# ---------- Node / TypeScript ----------
if [ -f package.json ]; then
  if [ -f pnpm-lock.yaml ]; then pm=pnpm
  elif [ -f yarn.lock ]; then pm=yarn
  elif [ -f bun.lockb ] || [ -f bun.lock ]; then pm=bun
  else pm=npm; fi

  has() { node -e 'const s=require("./package.json").scripts||{};process.exit(s[process.argv[1]]?0:1)' "$1"; }

  if has lint; then run lint "$pm" run lint; else skip lint "no lint script"; fi

  if has typecheck; then run typecheck "$pm" run typecheck
  elif has type-check; then run typecheck "$pm" run type-check
  elif [ -f tsconfig.json ]; then run typecheck npx --no-install tsc --noEmit
  else skip typecheck "no typecheck script or tsconfig"; fi

  if has test; then run test "$pm" run test; else skip test "NO TEST SCRIPT - add tests first"; fi

  if [ "$FULL" = 1 ]; then
    if has build; then run build "$pm" run build; else skip build "no build script"; fi
  fi
fi

# ---------- Java (Maven / Gradle) ----------
if [ -f pom.xml ]; then
  if [ -x ./mvnw ]; then mvn_cmd=./mvnw; else mvn_cmd=mvn; fi
  run verify "$mvn_cmd" -q -B verify
elif [ -f build.gradle ] || [ -f build.gradle.kts ]; then
  if [ -x ./gradlew ]; then gr=./gradlew; else gr=gradle; fi
  run check "$gr" check --console=plain -q
fi

# ---------- Rust ----------
if [ -f Cargo.toml ]; then
  run clippy cargo clippy --all-targets -- -D warnings
  run cargo-test cargo test
fi

if [ "$ran" -eq 0 ]; then
  echo "NO GATES DETECTED in $(pwd). Not a pass. Add lint/typecheck/test scripts or run from the package root."
  exit 3
fi

if [ "$fail" -eq 0 ]; then
  if [ "$skipped" -gt 0 ]; then
    echo "RAN GATES PASSED ($ran ran, $skipped SKIPPED - skipped is not verified)"
  else
    echo "ALL GATES PASSED ($ran)"
  fi
  exit 0
fi
echo "$fail of $ran gate(s) FAILED"
exit 1
