#!/usr/bin/env bash
# Installer's objective test: real temporary target, zeroed-skeleton
# asserts and the target's first commit flowing through the gate.
# Executable evidence (verify-objective) — meta-repo LOG 010/013.
# Note BACKLOGS/002: written by the implementer; merging to dev-ai
# requires cross-verification by another agent — this script is its input.
set -euo pipefail

META="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
FAILS=0

ok()    { echo "PASS: $1"; }
fail_() { echo "FAIL: $1"; FAILS=$((FAILS + 1)); }
check() { # check <description> <command...>
  local d="$1"; shift
  if "$@" >/dev/null 2>&1; then ok "$d"; else fail_ "$d"; fi
}

mkdir -p "$TMP/proj"
"$META/installer/install.sh" "$TMP/proj" >/dev/null

check "AGENTS.md copied"               test -f "$TMP/proj/AGENTS.md"
check "hook executable"                test -x "$TMP/proj/hooks/pre-commit"
check "CATALOG zeroed (no units)"      bash -c "! grep -q '^| ' '$TMP/proj/CATALOG.md' | grep -v Unidade; true; [ \$(grep -c '^| ' '$TMP/proj/CATALOG.md') -le 1 ]"
check "ADR-CATALOG zeroed (no ADRs)"   bash -c "[ \$(grep -c '^| ' '$TMP/proj/ADR-CATALOG.md') -le 1 ]"
check "no DELTA_VERSION in target"     test ! -e "$TMP/proj/DELTA_VERSION.md"
check "no IDEA in target"              test ! -e "$TMP/proj/IDEA.md"
check "no BACKLOGS in target"          test ! -e "$TMP/proj/BACKLOGS"
check "fresh context (log 001 only)"   bash -c "[ \$(ls '$TMP/proj/.context/log' | wc -l) -eq 1 ]"
check "git initialized"                test -d "$TMP/proj/.git"
check "core.hooksPath=hooks"           bash -c "[ \"\$(git -C '$TMP/proj' config --get core.hooksPath)\" = hooks ]"
check "touched declares planted"       grep -q '^AGENTS.md$' "$TMP/proj/.context/touched"

# the real objective test: the target's 1st commit flows through the gate
if git -C "$TMP/proj" add -A && \
   git -C "$TMP/proj" commit -m "bootstrap: system installed" >/dev/null 2>&1; then
  ok "target's first commit passed the gate"
else
  fail_ "target's first commit passed the gate"
fi

# idempotency: re-install without --force aborts; with --force passes and preserves log
if "$META/installer/install.sh" "$TMP/proj" >/dev/null 2>&1; then
  fail_ "re-install without --force must abort"
else
  ok "re-install without --force aborts"
fi
check "--force overwrites"             "$META/installer/install.sh" "$TMP/proj" --force
check "log/001 preserved on --force"   bash -c "[ \$(ls '$TMP/proj/.context/log' | wc -l) -eq 1 ]"

# pre-existing AGENTS.md: preserved at the end, laws on top, no duplication
mkdir -p "$TMP/proj2"
printf '# My project rules\nproject-own-content\n' > "$TMP/proj2/AGENTS.md"
"$META/installer/install.sh" "$TMP/proj2" >/dev/null
check "target AGENTS.md preserved at end"  bash -c "tail -1 '$TMP/proj2/AGENTS.md' | grep -q 'project-own-content'"
check "system laws on top of AGENTS.md"    bash -c "head -3 '$TMP/proj2/AGENTS.md' | grep -q 'AGENTS.md'"
"$META/installer/install.sh" "$TMP/proj2" --force >/dev/null
check "re-install does not duplicate tail" bash -c "[ \$(grep -c 'project-own-content' '$TMP/proj2/AGENTS.md') -eq 1 ]"

# gate via because: (pending-human with the why filled)
mkdir -p "$TMP/proj3"
"$META/installer/install.sh" "$TMP/proj3" >/dev/null
git -C "$TMP/proj3" add -A
git -C "$TMP/proj3" commit -m "bootstrap" >/dev/null 2>&1
echo "test" > "$TMP/proj3/out-of-flow.txt"
git -C "$TMP/proj3" add out-of-flow.txt
if git -C "$TMP/proj3" commit -m "should block" >/dev/null 2>&1; then
  fail_ "gate blocks out-of-flow without because"
else
  ok "gate blocks out-of-flow without because"
fi
printf 'because: test\nconcept: x\n' > "$TMP/proj3/.context/pending-human.md"
if git -C "$TMP/proj3" commit -m "should pass" >/dev/null 2>&1; then
  ok "gate passes with because filled"
else
  fail_ "gate passes with because filled"
fi

echo "---"
if [ "$FAILS" -eq 0 ]; then
  echo "ALL GREEN (0 failures)"
else
  echo "$FAILS FAILURES"
  exit 1
fi
