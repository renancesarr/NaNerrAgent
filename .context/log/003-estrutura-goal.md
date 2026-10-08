# 003 — backlog da estrutura goal/ (média)
quando: 2026-10-08
input: pedido do usuário — pasta goal/ com GOAL.md, macro-goal/, micros
       numerados; melhorias pendentes; descrever como implementação futura
       em BACKLOGS/
classificação (conter, ANTES): média — uma unidade nova de docs, decisão
       estrutural leve, sem código; a implementação em si fica no backlog
clarificar leve: ambiguidades não-bloqueantes viraram "Aberturas" dentro
       do arquivo (goal≡checkpoint? skill nova? arquivamento? ADR?) —
       decidir quando implementar
implements: nenhuma aplicável — task de spec/docs
output: BACKLOGS/001-estrutura-goal.md (proposta original preservada + v2
       melhorada + integração + aberturas + critérios de aceite), CATALOG.md
       +1 linha, NOW atualizado
evidência (verificar-objetivo):
  $ ls BACKLOGS/ → 001-estrutura-goal.md
  $ grep -c '^## ' BACKLOGS/001-estrutura-goal.md → 8 seções completas
  $ grep -n "BACKLOGS" CATALOG.md → linha 23 indexando a unidade
  $ grep macro-goal/macro/ → proposta original (l.26) E v2 (l.37) presentes
  commit deste fechamento passa pelo gate (staged ⊆ .context/touched,
  pending vazio) — a existência do commit é a prova
próxima: primeira task real; BACKLOGS/001 espera implementação
