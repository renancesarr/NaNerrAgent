# 012 — instalador v2: merge de AGENTS.md + anonimato de alvos (média)
quando: 2026-10-08
input: pedido do usuário — (1) registros devem só dizer que o primeiro
       teste funcionou; (2) instalador deve lidar com AGENTS.md existente
       sem cerimônia; (3) o meta-repo não deve conhecer a existência do
       projeto-alvo
classificação (conter, ANTES): média — muda comportamento do instalador
       (unidade installer/), formaliza política de registro e emenda ADR
mudanças:
  - install.sh: AGENTS.md existente SAI da lista de conflitos; conteúdo
    antigo é preservado verbatim no FINAL do novo; guard por header
    impede duplicação em re-install (contencao: renovar leis preservando
    cauda fica para upgrade real das leis)
  - test-install.sh: +3 asserts (preservado no final, leis no topo,
    não-duplicação no --force)
  - ADR-0011 emenda 1: merge de AGENTS.md + anonimato de alvos
  - política: meta-repo NÃO registra identidade de alvos (path, stack,
    dados) — "instalação funcionou" é o máximo de informação
exceção ao append-only, autorizada pelo usuário: LOG 011 foi reescrito
       (amend 83d3847→80565c2 + força-push em dev-ai-zcode) para remover
       identidade do alvo que eu havia registrado. O passado foi editado
       PORQUE continha o dado que o dono mandou não existir; a edição em
       si fica registrada aqui, para sempre.
evidência (verificar-objetivo):
  $ installer/test-install.sh → PASS ×18 → TUDO VERDE (0 falhas),
  incluindo os 3 novos de AGENTS.md pré-existente
próxima: pendências (achados 1–2 da auditoria; BACKLOGS/001; resto 002;
verificação cruzada p/ dev-ai — LOG 010+012 são o insumo)
