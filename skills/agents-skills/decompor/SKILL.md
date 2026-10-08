---
name: decompor
description: >
  Divide o objetivo clarificado em checkpoint → macro → micro-objetivo, cada
  micro com spec verificável e teste do objetivo pré-definido. Cria e mantém
  o PLAN. Usar após clarificar em tasks grandes; em modo mínimo em tasks
  médias. Não usar em triviais.
---

# decompor

## Objetivo
Nenhuma task maior que uma sessão. Nenhum micro sem definição de "pronto".
O retrabalho de fronteira movida no meio é o custo que esta skill evita.

## Artefatos — papéis distintos (não confundir)
| Artefato | Mutável? | Papel | Teto |
|---|---|---|---|
| `.context/NOW.md` | reescrito | onde ESTOU (1 micro + próximo passo) | 100 linhas |
| `.context/PLAN.md` | mutável | o MAPA inteiro: micros, dependências, specs, status | — |
| `.context/log/NNN-*.md` | **nunca** | o que ACONTECEU, em ordem | 60 linhas/entrada |

A spec de um micro mora no PLAN. O LOG registra a transição; o NOW aponta.
Specs evoluem (critérios concluídos, ajustes) — por isso não moram no LOG.

## Estrutura
- **checkpoint** — macro-entregável (semanas). Existe só em tasks grandes.
- **macro-objetivo** — componente do checkpoint (1–2 semanas).
- **micro** — task atômica: uma sessão, um diff, uma entrada de LOG.

## Réguas de tamanho do micro (verificáveis, não "horas")
Um micro está no tamanho certo quando TODAS valem:
1. O diff esperado é descritível em uma frase. Não consegue? São dois micros.
2. Tem ≤ 5 critérios verificáveis independentes. Mais que isso? São dois micros.
3. Toca ≤ 6 unidades (criar + alterar). Mais? Quebre por unidade ou fronteira.
4. Não contém decisão de domínio nova (isso é `modelar-dominio` antes, no pipeline grande).

## Processo
1. Input: o prompt canônico de `clarificar`.
2. **Task média** → modo mínimo: UMA spec, sem checkpoint, sem macro.
   Hierarquia para um micro único é cerimônia (YAGNI aplicado à decomposição).
3. **Task grande** → liste checkpoints → quebre em macros → quebre em micros.
4. Escreva o PLAN:

```markdown
# PLAN — [objetivo canônico, 1 linha]

## Mapa
| # | micro | dep. de | status | teste do objetivo (1 linha) |
|---|-------|---------|--------|---------------------------|
| 1 | ...   | —       | pendente| ... |
| 2 | ...   | 1       | pendente| ... |

## Specs
### [1] nome
objetivo: [1–2 linhas]
critérios: [ ] ... (≤5, cada um verificável sozinho)
dependências: [— ou micros]
unidades: [a criar/alterar, se conhecidas]
premissas herdadas: [não validadas da clarificação, se houver]
teste do objetivo: [como um QA validaria ESTE micro — comando/observação]
```

5. **Granularidade de spec**: mapa completo sempre; specs detalhadas só para
   os próximos 2–3 micros; rascunho (objetivo + teste, 1 linha) para os
   distantes. Spec detalhada de micro distante é ficção — micros anteriores
   invalidam suas premissas. Detalhe quando chegar a vez.
6. Priorize: valor primeiro, risco cedo (o micro que pode revelar que o plano
   está errado vem antes de qualquer polimento), dependências respeitadas.
7. **A regra de ferro**: se você não consegue escrever o `teste do objetivo`
   de um micro, o micro está mal definido — você não sabe o que é "pronto".
   Redefina o micro; não deixe o campo vazio. `verificar-objetivo` recebe
   campo vazio → devolve para cá. O loop é desenhado para voltar.
8. Registre a transição. LOG: `checkpoints/macros criados`, `N micros no
   mapa`, `primeiro micro + por quê essa ordem`. NOW: primeiro micro como
   "próximo passo imediato", apontando o PLAN.

## Diagnóstico reverso (ADRs 0008/0009)
| Sintoma (achado depois) | Causa aqui | Correção |
|---|---|---|
| NOW estoura o teto de 100 linhas | micro grande demais | volte, quebre o micro atual |
| implementar gera diff fora da spec | micro mal definido (frase do diff impossível) | reescreva a spec antes de prosseguir |
| verificar-objetivo "inventa" teste | campo vazio ou vago na spec | a culpa é daqui, não de lá |

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "É simples, vou direto" | Simples de verdade = trivial → reclassifique via conter. Média sem spec = o gate vai inventar o próprio teste. |
| "Decompo conforme avanço" | Fronteira movida no meio re-custa tudo que já encostou nela. O mapa completo existe para ver dependências ANTES. |
| "Specs são burocracia" | A spec é o contrato do gate QA. Sem ela, quem corrige define o que é "passou". |
| "Detalho todas as specs já" | Spec detalhada de micro distante é ficção de planejamento. Mapa completo, detalhe just-in-time. |

## Verificação
- [ ] Todo micro do mapa tem: nome, dependência, teste do objetivo (ainda que rascunho).
- [ ] Specs detalhadas (próximos 2–3) têm critérios ≤5 e teste do objetivo preenchido.
- [ ] Task média gerou UMA spec sem hierarquia. Task grande tem mapa completo.
- [ ] PLAN.md criado; NOW aponta para ele e carrega só o primeiro micro.
- [ ] Nenhum micro no mapa contém decisão de domínio embutida (se contém, o pipeline grande exige `modelar-dominio` antes).