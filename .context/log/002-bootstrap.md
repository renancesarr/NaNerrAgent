# 002 — bootstrap + otimização (implementar → verificar-objetivo)
quando: 2026-10-08
input: DELTA_VERSION.md (blueprint), IDEIA.md (visão), repo com AGENTS.md e
       9 skills prontas; catálogos, ADR-exemplo, hook, NOW e LOG vazios/ausentes;
       repo sem git
classificação (conter, ANTES da execução): grande — várias unidades, muda o
       estado global do repo (git, gate, catálogos, instalação CLI)
escopo decidido com o usuário: só o bootstrap (DELTA_VERSION.md intacto,
       sem trim das skills) + instalação apenas no ZCode
implements selecionadas: nenhuma aplicável — meta-repo é docs/bootstrap,
       sem dialeto de implementação (lacuna catalogada em IMPLEMENTS-CATALOG)
objetivo: bootstrap funcional — artefatos completos, gate executável,
       primeiro commit através do gate, 9 skills visíveis no ZCode
teste do objetivo: cenários 1–3 do gate com comando+saída abaixo; índice
       responde "quem classifica tasks?" em uma leitura
evidência: (ver seção Evidência abaixo)
unidades: hooks/pre-commit, CATALOG.md, ADR-CATALOG.md, IMPLEMENTS-CATALOG.md,
       docs/adr/0001-unidade-coesa.md, .context/{NOW.md,touched,pending-human.md}

## Evidência (verificar-objetivo)

Cenário 1 — fora do fluxo, sem porque ⇒ BLOQUEIA:
  $ echo "conteudo de teste" > arquivo-teste-gate.txt
  $ git add arquivo-teste-gate.txt && git commit -m "teste do gate: deve bloquear"
  ✋ Fora do fluxo do agente:
  arquivo-teste-gate.txt
  Preencha .context/pending-human.md: ...
  EXIT_CODE=1

Cenário 2 — porque preenchido ⇒ PASSA (após fix, ver abaixo):
  $ printf 'porque: teste automatizado do gate (cenário 2)\n...' > .context/pending-human.md
  $ git commit -m "teste do gate: deve passar com porque"
  [main cfe7d9f] teste do gate: deve passar com porque
  EXIT_CODE=0
  (commit de teste descartado em seguida: git reset HEAD~1; estado restaurado)

Cenário 3 — via agente (staged ⊆ .context/touched, pending vazio) ⇒ PASSA:
  commit raiz 82e5825 (23 arquivos) e fix f1cc38d, ambos com pending template vazio.

Teste do índice (métrica 1 da IDEIA — achar em 1 leitura):
  $ grep -in "classifica" CATALOG.md
  17:| skills/agents-skills/conter | classifica task trivial/média/grande ANTES + fast path + contenção |

Instalação ZCode: 9 symlinks em ~/.agents/skills/* → repo (verificados via
  head -1 <symlink>/SKILL.md; sem colisões de nome pré-existentes).

## Cicatrizes de produção (dogfood do 1º commit)

1. comm×locale: `comm` compara em ordem de byte; `sort` no locale pt_BR.UTF-8
   diverge ⇒ "comm: o arquivo 1 não está em ordem". Fix: LC_ALL=C nos três.
2. grep BRE: `grep -q '^porque: .+'` nunca casa ('+' literal em BRE) ⇒ a via
   do porque estava MORTA desde o blueprint. Fix: grep -Eq. O cenário 2
   expôs porque exigiu evidência executável, não "parece certo".

Resultado: REPROVADO→corrigido→verde. 3 commits no main (82e5825, f1cc38d,
+ fechamento), working tree limpo, gate validado nas 3 vias.
