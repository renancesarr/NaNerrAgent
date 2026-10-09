#!/usr/bin/env bash
# Installs the NaNerr-agent system into a target project: laws + gate +
# zeroed catalogs + fresh context (ADR-0011). Skills stay global per CLI —
# this script does NOT copy skills or any meta-repo history
# (DELTA_VERSION, IDEA, BACKLOGS, docs/, LOG) — the whitelist guarantees.
set -euo pipefail

META="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TPL="$META/installer/templates"

usage() { echo "usage: installer/install.sh <target-project-dir> [--force]"; exit 1; }

[ $# -ge 1 ] && [ "$1" != "--force" ] || usage
TARGET="$1"; shift || true
FORCE=0
for a in "$@"; do
  case "$a" in
    --force) FORCE=1 ;;
    *) usage ;;
  esac
done

[ -d "$TARGET" ] || { echo "✋ target not found: $TARGET"; exit 1; }
TARGET="$(cd "$TARGET" && pwd)"
[ "$TARGET" != "$META" ] || { echo "✋ do not install over the meta-repo itself"; exit 1; }

# conflicts: only overwrites with --force; .context/log/ is never destroyed
# (AGENTS.md is NOT in this list: an existing one is preserved — see below)
CONFLICTS=()
for f in CATALOG.md ADR-CATALOG.md IMPLEMENTS-CATALOG.md \
         hooks/pre-commit hooks/check-agent-branch.sh \
         hooks/pre-merge-commit .context/NOW.md; do
  if [ -e "$TARGET/$f" ]; then CONFLICTS+=("$f"); fi
done
if [ "${#CONFLICTS[@]}" -gt 0 ] && [ "$FORCE" -ne 1 ]; then
  echo "✋ already installed (or files exist):"
  printf '  %s\n' "${CONFLICTS[@]}"
  echo "use --force to overwrite (.context/log/ is preserved)"
  exit 1
fi

# git: the whole gate depends on it
if [ ! -d "$TARGET/.git" ]; then
  git -C "$TARGET" init -b main >/dev/null
  echo "· git initialized (main)"
fi
git -C "$TARGET" config core.hooksPath hooks

# core copied from the meta-repo's living source
# AGENTS.md — an existing one is preserved VERBATIM at the end of the new one
# (ADR-0011, amendment 1). Guard: header equal to the system's = already
# merged; contencao: re-install does not renew laws nor duplicate the tail;
# migrate when there is a real law upgrade
if [ -f "$TARGET/AGENTS.md" ]; then
  if [ "$(head -1 "$TARGET/AGENTS.md")" != "$(head -1 "$META/AGENTS.md")" ]; then
    OLD="$(mktemp)"
    cp "$TARGET/AGENTS.md" "$OLD"
    install -m 644 "$META/AGENTS.md" "$TARGET/AGENTS.md"
    printf '\n' >> "$TARGET/AGENTS.md"
    cat "$OLD" >> "$TARGET/AGENTS.md"
    rm -f "$OLD"
  fi
else
  install -m 644 "$META/AGENTS.md" "$TARGET/AGENTS.md"
fi
mkdir -p "$TARGET/hooks"
install -m 755 "$META/hooks/pre-commit" "$TARGET/hooks/pre-commit"
install -m 755 "$META/hooks/check-agent-branch.sh" "$TARGET/hooks/check-agent-branch.sh"
install -m 755 "$META/hooks/pre-merge-commit" "$TARGET/hooks/pre-merge-commit"

# zeroed skeleton (templates)
install -m 644 "$TPL/CATALOG.md"            "$TARGET/CATALOG.md"
install -m 644 "$TPL/ADR-CATALOG.md"        "$TARGET/ADR-CATALOG.md"
install -m 644 "$TPL/IMPLEMENTS-CATALOG.md" "$TARGET/IMPLEMENTS-CATALOG.md"
mkdir -p "$TARGET/.context/log"
install -m 644 "$TPL/NOW.md"                "$TARGET/.context/NOW.md"
install -m 644 "$TPL/pending-human.md"      "$TARGET/.context/pending-human.md"
install -m 644 "$TPL/touched"               "$TARGET/.context/touched"
if [ ! -e "$TARGET/.context/log/001-installation.md" ]; then
  sed "s/<DATE>/$(date +%Y-%m-%d)/" "$TPL/log-001-installation.md" \
    > "$TARGET/.context/log/001-installation.md"
fi

echo "✓ system installed in $TARGET"
echo "  next: cd $TARGET && git add -A && git commit -m 'bootstrap: system installed'"
echo "  (planted files are already declared in .context/touched — the gate lets it pass)"
