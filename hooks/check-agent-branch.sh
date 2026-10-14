#!/usr/bin/env bash
# Enforce this repository's agent identity-to-branch mapping when configured.
set -euo pipefail

MAP=".context/agent-branches"
[ -f "$MAP" ] || exit 0

reject() {
  echo "✋ Agent branch lock: $*" >&2
  exit 1
}

BRANCH="$(git branch --show-current)"
NAME="$(git config --get user.name || true)"
EMAIL="$(git config --get user.email || true)"
AGENT_ID="$(git config --get agent.id || true)"

[ -n "$BRANCH" ] || reject "detached HEAD cannot create a commit."

if [ -n "$AGENT_ID" ]; then
  MATCHES="$(awk -F '|' -v id="$AGENT_ID" '$1 !~ /^[[:space:]]*#/ && NF == 4 && $1 == id { print }' "$MAP")"
else
  MATCHES="$(awk -F '|' -v name="$NAME" -v email="$EMAIL" '$1 !~ /^[[:space:]]*#/ && NF == 4 && ($2 == name || $3 == email) { print }' "$MAP")"
fi
COUNT="$(awk 'NF { n++ } END { print n+0 }' <<< "$MATCHES")"

[ "$COUNT" -le 1 ] || reject "identity matches multiple rows in $MAP."

if [ "$COUNT" -eq 1 ]; then
  IFS='|' read -r EXPECTED_ID EXPECTED_NAME EXPECTED_EMAIL EXPECTED_BRANCH <<< "$MATCHES"
  [ -z "$AGENT_ID" ] || [ "$AGENT_ID" = "$EXPECTED_ID" ] ||
    reject "agent.id '$AGENT_ID' does not match the Git identity."
  [ "$NAME" = "$EXPECTED_NAME" ] ||
    reject "Git name '$NAME' does not match agent '$EXPECTED_ID' (expected '$EXPECTED_NAME')."
  [ "$EMAIL" = "$EXPECTED_EMAIL" ] ||
    reject "Git email '$EMAIL' does not match agent '$EXPECTED_ID' (expected '$EXPECTED_EMAIL')."
  [ "$BRANCH" = "$EXPECTED_BRANCH" ] ||
    reject "agent '$EXPECTED_ID' must commit on '$EXPECTED_BRANCH', current branch is '$BRANCH'."
  exit 0
fi

[ -z "$AGENT_ID" ] ||
  reject "unknown agent.id '$AGENT_ID'; add an approved identity/branch row before committing."

if awk -F '|' -v branch="$BRANCH" '$1 !~ /^[[:space:]]*#/ && NF == 4 && $4 == branch { found=1 } END { exit !found }' "$MAP"; then
  reject "unknown Git identity '$NAME <$EMAIL>' on reserved branch '$BRANCH'."
fi

exit 0
