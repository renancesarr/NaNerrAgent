---
name: verificar-objetivo
description: >
  O gate de entrega (ADR-0005): valida micro e objetivo como um QA testaria —
  comportamento, integração, aceitação, com evidência executável registrada.
  A spec é o oráculo; o código é caixa-preta. Roda ao fechar todo micro
  (implementado → concluído) e ao fechar o objetivo inteiro. Não roda em
  triviais — conter já os isentou.
---

# verificar-objetivo

## Objetivo
Provar que o que foi pedido aconteceu — com evidência reproduzível, nunca
afirmação. Esta skill é o gate: nada que não passou por ela entrega.

## Hierarquia fixa (AGENTS.md §5)
| Evidência | Valor |
|---|---|
| teste do OBJETIVO passando, com evidência | **gate de entrega** |
| unitário verde (TDD) | higiene interna |
| "analisei o código, está correto" | não é evidência |

Unitário verde + objetivo quebrado = REPROVADO. Sem apelação.

## Caixa-preta — o oráculo é a spec, nunca o código
Quem escreveu o código tem viés de confirmação; a defesa é estrutural:
- `esperado:` deriva da spec e é escrito ANTES de executar.
- Leu o código para descobrir o que esperar? Testou o código contra ele
  mesmo — tautologia, não verificação.
- O LOG registra `esperado / obtido / resultado` por critério. Esperado
  idêntico ao obtido em 100% do histórico é cheirável pelo `auditar`.

## Dois escopos
| Escopo | Oráculo | Quando |
|---|---|---|
| micro-gate | spec do micro: teste do objetivo + critérios | todo micro implementado |
| objetivo-gate | prompt canônico (LOG de clarificar) + premissas delegadas | último micro verde |

O objetivo-gate existe porque **soma de micros verdes ≠ objetivo entregue** —
é a falha clássica: tudo verde, o sistema não faz a coisa. Teste contra o
pedido, não contra a soma das partes.

## Formas válidas (a forma varia por projeto; a exigência não)
1. **executável** — comando + saída, re-executável (instável = falha)
2. **interativa instrumentada** — passos + observações registradas
3. **preparada para humano** — agente entrega passos + esperados; humano
   executa e reporta. Status `pendente-verificação` até o reporte.
   Preparada nunca é passada. Nunca.

## Processo
1. Micro-gate: releia a spec. `teste do objetivo` vazio ou vago?
   → **volte ao decompor** (a regra de ferro de lá). Não invente o teste
   agora: teste inventado na hora testa o que o código faz, não o que foi pedido.
2. Escreva `esperado:` para cada critério — da spec, antes de executar.
3. Execute o teste do objetivo sobre o estado real (commitado/staged).
   Registre `obtido:` e `resultado: pass|fail` por critério.
4. Checklist de rejeição (qualquer item reprova):
   - [ ] testado como comportamento, não como estrutura
   - [ ] caminhos de erro exercitados: entrada inválida, limite, vazio
   - [ ] integração entre as unidades do micro exercitada, não só isoladas
   - [ ] evidência reproduzível no LOG
5. **Falhou → três rotas, nunca silêncio:**
   | Causa | Rota |
   |---|---|
   | bug no código | corrige (escopo implementar), re-executa o gate |
   | bug mecânico no teste | corrige o teste, re-executa |
   | expectativa errada | é MUDANÇA DE SPEC: edita PLAN + registra no LOG |
   Mudar o esperado em silêncio para o teste passar é como todo gate apodrece.
6. **Mesmo critério falha pela 3ª vez → PARE.** O problema é upstream:
   spec má, abordagem errada, micro grande demais. Volte a decompor/conter
   carregando o registro das falhas. Loop de patch infinito é dívida com juros.
7. Objetivo-gate: releia o prompt canônico no LOG de clarificar. Verifique a
   entrega contra ELE. **Premissa delegada que virou estrutural** é exposta na
   entrega: "você delegou X; construímos sobre X; confirme". O loop que
   clarificar abriu, fecha aqui.
8. Verde → PLAN: `concluído` — status que só esta skill escreve (implementar
   marca `implementado`; execução não atesta entrega). Reprovado → NOW volta
   ao micro em rework. O gate roda sobre o estado real: reprovação vira
   commit de correção — histórico honesto, não commit escondido.
9. Registre a transição (AGENTS.md §6): comandos, esperado/obtido, verdict.

## Diagnóstico: a falta de falhas é sintoma
LOG de verificação com 100% de pass desde o início = esperado colado no
obtido, ou teste trivial demais para falhar. Falhas ocasionais são a
evidência de verificação honesta. O `auditar` confere isto.

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "Unitários todos verdes" | Hierarquia §5: verde no degrau errado não entrega. |
| "Testar objetivo é caro" | Mais caro: usuário descobrindo. |
| "Vou validar manual depois" | "Depois" é onde objetivos vão morrer (AGENTS.md §5). |
| "Li o código, está certo" | Caixa-preta furada = tautologia. A spec é o oráculo. |
| "O teste falhou, ajusto o esperado" | Esperado é spec. A rota certa está no passo 5 — em silêncio, nunca. |
| "Falhou de novo, tento mais uma" | 3ª falha do mesmo critério = upstream. Pare e diagnostique. |
| "Preparei os passos pro usuário" | Preparada ≠ executada. pendente-verificação até o reporte. |

## Verificação
- [ ] `esperado:` registrado antes da execução, para todo critério.
- [ ] Evidência executável ou observação registrada — afirmação não conta.
- [ ] Erros e integração exercitados, não só o caminho feliz.
- [ ] Toda falha roteada (código/teste/spec) — zero esperado mudado em silêncio.
- [ ] Nenhum critério passou da 3ª falha sem parada e diagnóstico.
- [ ] Objetivo-gate testou contra o prompt canônico; premissas delegadas expostas.
- [ ] `concluído` no PLAN foi escrito por esta skill — e por nada mais.
```