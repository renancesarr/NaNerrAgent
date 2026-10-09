#!/usr/bin/env bash
# Installer's objective test: real temporary targets, zeroed-skeleton
# asserts, first commit, and agent branch/identity enforcement.
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
check "branch guard executable"        test -x "$TMP/proj/hooks/check-agent-branch.sh"
check "merge hook executable"          test -x "$TMP/proj/hooks/pre-merge-commit"
check "agent map remains meta-only"    test ! -e "$TMP/proj/.context/agent-branches"
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


# agent branch lock: targets get the helper but not the meta-repository map
mkdir -p "$TMP/agent-lock"
"$META/installer/install.sh" "$TMP/agent-lock" >/dev/null
git -C "$TMP/agent-lock" config user.name "Test Author"
git -C "$TMP/agent-lock" config user.email "test@example.invalid"
git -C "$TMP/agent-lock" add -A
git -C "$TMP/agent-lock" commit -m "bootstrap" >/dev/null 2>&1
git -C "$TMP/agent-lock" switch -c dev-ai-codex >/dev/null
cat > "$TMP/agent-lock/.context/agent-branches" <<'MAP'
# agent-id|git-name|git-email|branch
codex-ai|codex-ai|codex-ai@nanerr.local|dev-ai-codex
zcode-ai|zcode-ai|zcode-ai@nanerr.local|dev-ai-zcode
MAP
printf '%s\n' '.context/agent-branches' '.context/touched' >> "$TMP/agent-lock/.context/touched"
LC_ALL=C sort -u "$TMP/agent-lock/.context/touched" -o "$TMP/agent-lock/.context/touched"
git -C "$TMP/agent-lock" config user.name "codex-ai"
git -C "$TMP/agent-lock" config user.email "codex-ai@nanerr.local"
git -C "$TMP/agent-lock" config agent.id "codex-ai"
git -C "$TMP/agent-lock" add .context/agent-branches .context/touched
if git -C "$TMP/agent-lock" commit -m "configure agent map" >/dev/null 2>&1; then
  ok "mapped Codex identity passes on dev-ai-codex"
else
  fail_ "mapped Codex identity passes on dev-ai-codex"
fi

git -C "$TMP/agent-lock" switch -c dev-ai-zcode >/dev/null
if git -C "$TMP/agent-lock" commit --allow-empty -m "wrong Codex branch" >/dev/null 2>&1; then
  fail_ "Codex identity blocked on dev-ai-zcode"
else
  ok "Codex identity blocked on dev-ai-zcode"
fi
git -C "$TMP/agent-lock" switch dev-ai-codex >/dev/null
git -C "$TMP/agent-lock" config user.email "wrong@nanerr.local"
if git -C "$TMP/agent-lock" commit --allow-empty -m "wrong email" >/dev/null 2>&1; then
  fail_ "mapped agent with wrong email is blocked"
else
  ok "mapped agent with wrong email is blocked"
fi
git -C "$TMP/agent-lock" config --unset agent.id
git -C "$TMP/agent-lock" config user.name "Unknown Agent"
git -C "$TMP/agent-lock" config user.email "unknown@nanerr.local"
if git -C "$TMP/agent-lock" commit --allow-empty -m "unknown identity" >/dev/null 2>&1; then
  fail_ "unknown identity blocked on reserved branch"
else
  ok "unknown identity blocked on reserved branch"
fi
git -C "$TMP/agent-lock" config user.name "codex-ai"
git -C "$TMP/agent-lock" config user.email "codex-ai@nanerr.local"
git -C "$TMP/agent-lock" config agent.id "codex-ai"
git -C "$TMP/agent-lock" checkout --detach HEAD >/dev/null 2>&1
if git -C "$TMP/agent-lock" commit --allow-empty -m "detached identity" >/dev/null 2>&1; then
  fail_ "detached agent HEAD is blocked"
else
  ok "detached agent HEAD is blocked"
fi
git -C "$TMP/agent-lock" checkout dev-ai-zcode >/dev/null
git -C "$TMP/agent-lock" config user.name "zcode-ai"
git -C "$TMP/agent-lock" config user.email "zcode-ai@nanerr.local"
git -C "$TMP/agent-lock" config agent.id "zcode-ai"
if git -C "$TMP/agent-lock" commit --allow-empty -m "ZCode identity" >/dev/null 2>&1; then
  ok "mapped ZCode identity passes on dev-ai-zcode"
else
  fail_ "mapped ZCode identity passes on dev-ai-zcode"
fi

# A merge commit is checked by pre-merge-commit, which keeps the normal
# staged/touched gate out of merged trees.
git -C "$TMP/agent-lock" config --unset agent.id
git -C "$TMP/agent-lock" config user.name "Test Author"
git -C "$TMP/agent-lock" config user.email "test@example.invalid"
git -C "$TMP/agent-lock" switch -c incoming >/dev/null
printf '%s\n' 'merge test' > "$TMP/agent-lock/incoming.txt"
printf '%s\n' 'incoming.txt' '.context/touched' >> "$TMP/agent-lock/.context/touched"
LC_ALL=C sort -u "$TMP/agent-lock/.context/touched" -o "$TMP/agent-lock/.context/touched"
git -C "$TMP/agent-lock" add incoming.txt .context/touched
if git -C "$TMP/agent-lock" commit -m "incoming change" >/dev/null 2>&1; then
  ok "unmapped author can commit on an unreserved branch"
else
  fail_ "unmapped author can commit on an unreserved branch"
fi
git -C "$TMP/agent-lock" switch dev-ai-codex >/dev/null
git -C "$TMP/agent-lock" config user.name "Unknown Agent"
git -C "$TMP/agent-lock" config user.email "unknown@nanerr.local"
if git -C "$TMP/agent-lock" merge --no-ff --no-edit incoming >/dev/null 2>&1; then
  fail_ "unknown identity blocked from merge commit on reserved branch"
else
  ok "unknown identity blocked from merge commit on reserved branch"
  git -C "$TMP/agent-lock" merge --abort >/dev/null 2>&1 || true
fi

echo "---"
if [ "$FAILS" -eq 0 ]; then
  echo "ALL GREEN (0 failures)"
else
  echo "$FAILS FAILURES"
  exit 1
fi
