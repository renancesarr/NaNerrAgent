#!/usr/bin/env bash
# Instala o sistema NaNerr-agent num projeto-alvo: leis + gate + catálogos
# zerados + contexto fresco (ADR-0011). Skills ficam globais por CLI —
# este script NÃO copia skills nem nada do histórico do meta-repo
# (DELTA_VERSION, IDEIA, BACKLOGS, docs/, LOG) — a whitelist garante.
set -euo pipefail

META="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TPL="$META/installer/templates"

uso() { echo "uso: installer/install.sh <dir-do-projeto-alvo> [--force]"; exit 1; }

[ $# -ge 1 ] && [ "$1" != "--force" ] || uso
ALVO="$1"; shift || true
FORCE=0
for a in "$@"; do
  case "$a" in
    --force) FORCE=1 ;;
    *) uso ;;
  esac
done

[ -d "$ALVO" ] || { echo "✋ alvo inexistente: $ALVO"; exit 1; }
ALVO="$(cd "$ALVO" && pwd)"
[ "$ALVO" != "$META" ] || { echo "✋ não instale sobre o próprio meta-repo"; exit 1; }

# conflitos: só sobrescreve com --force; .context/log/ nunca é destruído
# (AGENTS.md NÃO está nesta lista: existente é preservado — ver abaixo)
CONFLITOS=()
for f in CATALOG.md ADR-CATALOG.md IMPLEMENTS-CATALOG.md \
         hooks/pre-commit .context/NOW.md; do
  if [ -e "$ALVO/$f" ]; then CONFLITOS+=("$f"); fi
done
if [ "${#CONFLITOS[@]}" -gt 0 ] && [ "$FORCE" -ne 1 ]; then
  echo "✋ já instalado (ou arquivos existem):"
  printf '  %s\n' "${CONFLITOS[@]}"
  echo "use --force para sobrescrever (.context/log/ é preservado)"
  exit 1
fi

# git: todo o gate depende dele
if [ ! -d "$ALVO/.git" ]; then
  git -C "$ALVO" init -b main >/dev/null
  echo "· git inicializado (main)"
fi
git -C "$ALVO" config core.hooksPath hooks

# núcleo: AGENTS.md — existente é preservado VERBATIM no final do novo
# (ADR-0011, emenda 1). Guard: header igual ao do sistema = já mergeado;
# contencao: re-install não renova leis nem duplica cauda; migrar quando
# houver upgrade real das leis
if [ -f "$ALVO/AGENTS.md" ]; then
  if [ "$(head -1 "$ALVO/AGENTS.md")" != "$(head -1 "$META/AGENTS.md")" ]; then
    VELHO="$(mktemp)"
    cp "$ALVO/AGENTS.md" "$VELHO"
    install -m 644 "$META/AGENTS.md" "$ALVO/AGENTS.md"
    printf '\n' >> "$ALVO/AGENTS.md"
    cat "$VELHO" >> "$ALVO/AGENTS.md"
    rm -f "$VELHO"
  fi
else
  install -m 644 "$META/AGENTS.md" "$ALVO/AGENTS.md"
fi
mkdir -p "$ALVO/hooks"
install -m 755 "$META/hooks/pre-commit" "$ALVO/hooks/pre-commit"

# esqueleto zerado (templates)
install -m 644 "$TPL/CATALOG.md"            "$ALVO/CATALOG.md"
install -m 644 "$TPL/ADR-CATALOG.md"        "$ALVO/ADR-CATALOG.md"
install -m 644 "$TPL/IMPLEMENTS-CATALOG.md" "$ALVO/IMPLEMENTS-CATALOG.md"
mkdir -p "$ALVO/.context/log"
install -m 644 "$TPL/NOW.md"                "$ALVO/.context/NOW.md"
install -m 644 "$TPL/pending-human.md"      "$ALVO/.context/pending-human.md"
install -m 644 "$TPL/touched"               "$ALVO/.context/touched"
if [ ! -e "$ALVO/.context/log/001-instalacao.md" ]; then
  sed "s/<DATA>/$(date +%Y-%m-%d)/" "$TPL/log-001-instalacao.md" \
    > "$ALVO/.context/log/001-instalacao.md"
fi

echo "✓ sistema instalado em $ALVO"
echo "  próximo: cd $ALVO && git add -A && git commit -m 'bootstrap: sistema instalado'"
echo "  (plantados já declarados em .context/touched — o gate deixa passar)"
