#!/usr/bin/env bash
# Teste do objetivo do instalador: alvo temporário REAL, asserts de
# esqueleto zerado e o primeiro commit do alvo passando pelo gate.
# Evidência executável (verificar-objetivo) — LOG 010 do meta-repo.
# Nota BACKLOGS/002: escrito pelo implementador; o merge à dev-ai exige
# verificação cruzada por outro agente — este script é o insumo dela.
set -euo pipefail

META="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
FALHAS=0

ok()    { echo "PASS: $1"; }
falha() { echo "FAIL: $1"; FALHAS=$((FALHAS + 1)); }
check() { # check <descrição> <comando...>
  local d="$1"; shift
  if "$@" >/dev/null 2>&1; then ok "$d"; else falha "$d"; fi
}

mkdir -p "$TMP/proj"
"$META/installer/install.sh" "$TMP/proj" >/dev/null

check "AGENTS.md copiado"              test -f "$TMP/proj/AGENTS.md"
check "hook executável"                test -x "$TMP/proj/hooks/pre-commit"
check "CATALOG zerado (sem unidades)"  bash -c "! grep -q '^| skills' '$TMP/proj/CATALOG.md'"
check "ADR-CATALOG zerado (sem ADRs)"  bash -c "! grep -q '0001' '$TMP/proj/ADR-CATALOG.md'"
check "sem DELTA_VERSION no alvo"      test ! -e "$TMP/proj/DELTA_VERSION.md"
check "sem IDEIA no alvo"              test ! -e "$TMP/proj/IDEIA.md"
check "sem BACKLOGS no alvo"           test ! -e "$TMP/proj/BACKLOGS"
check "contexto fresco (só log 001)"   bash -c "[ \$(ls '$TMP/proj/.context/log' | wc -l) -eq 1 ]"
check "git inicializado"              test -d "$TMP/proj/.git"
check "core.hooksPath=hooks"           bash -c "[ \"\$(git -C '$TMP/proj' config --get core.hooksPath)\" = hooks ]"
check "touched declara os plantados"   grep -q '^AGENTS.md$' "$TMP/proj/.context/touched"

# o teste do objetivo de verdade: o 1º commit do alvo flui pelo gate
if git -C "$TMP/proj" add -A && \
   git -C "$TMP/proj" commit -m "bootstrap: sistema instalado" >/dev/null 2>&1; then
  ok "primeiro commit do alvo passou pelo gate"
else
  falha "primeiro commit do alvo passou pelo gate"
fi

# idempotência: re-install sem --force aborta; com --force passa e preserva log
if "$META/installer/install.sh" "$TMP/proj" >/dev/null 2>&1; then
  falha "re-install sem --force deve abortar"
else
  ok "re-install sem --force aborta"
fi
check "--force sobrescreve"            "$META/installer/install.sh" "$TMP/proj" --force
check "log/001 preservado no --force"  bash -c "[ \$(ls '$TMP/proj/.context/log' | wc -l) -eq 1 ]"

# AGENTS.md pré-existente: preservado no final, leis no topo, sem duplicar
mkdir -p "$TMP/proj2"
printf '# Regras do meu projeto\nconteudo-proprio-do-projeto\n' > "$TMP/proj2/AGENTS.md"
"$META/installer/install.sh" "$TMP/proj2" >/dev/null
check "AGENTS.md alvo preservado no final"   bash -c "tail -1 '$TMP/proj2/AGENTS.md' | grep -q 'conteudo-proprio'"
check "leis do sistema no topo do AGENTS.md" bash -c "head -3 '$TMP/proj2/AGENTS.md' | grep -q 'AGENTS.md'"
"$META/installer/install.sh" "$TMP/proj2" --force >/dev/null
check "re-install não duplica a cauda"       bash -c "[ \$(grep -c 'conteudo-proprio' '$TMP/proj2/AGENTS.md') -eq 1 ]"

echo "---"
if [ "$FALHAS" -eq 0 ]; then
  echo "TUDO VERDE (0 falhas)"
else
  echo "$FALHAS FALHAS"
  exit 1
fi
