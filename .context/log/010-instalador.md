# 010 — instalador de projeto (feature/instalador) (média)
quando: 2026-10-08
input: pedido do usuário — instalar o sistema num projeto novo, SEM os
       docs do meta-repo (DELTA_VERSION, etc.), catálogos zerados,
       contexto zerado; pergunta: como desenvolver?
classificação (conter, ANTES): média — feature de uma unidade nova
       (installer/) com lógica real e teste do objetivo; primeiro uso
       do fluxo feature/* do BACKLOGS/002 (branch a partir de dev-ai-zcode)
design (a resposta ao "como"):
       whitelist — copiar SÓ o esqueleto universal (AGENTS.md e hook da
       fonte viva; catálogos + .context zerados de templates); skills
       ficam globais por CLI (fonte única no meta-repo, ADR-0011);
       idempotente (aborta em conflito, --force preserva .context/log/);
       touched nasce declarando os plantados → 1º commit do alvo já flui
       pelo gate
implements: nenhuma aplicável — bash/stdlib, sem dependência nova (escada
       degrau 3)
output: installer/{install.sh,test-install.sh,templates/×7}, ADR-0011
       completa + linha no ADR-CATALOG, CATALOG +3 linhas
evidência (verificar-objetivo):
  $ installer/test-install.sh
  PASS ×15 — incluindo: catálogos zerados, sem DELTA/IDEIA/BACKLOGS no
  alvo, contexto fresco (só log 001), git init + hooksPath, e o gate de
  verdade: "primeiro commit do alvo passou pelo gate"; idempotência
  (re-install aborta; --force preserva log/001) → TUDO VERDE (0 falhas)
nota BACKLOGS/002: teste escrito pelo implementador (ZCode); o merge à
       dev-ai exige verificação cruzada — este LOG é o insumo do verificador
próxima: merge feature→dev-ai-zcode (autor); verificação cruzada p/ dev-ai
