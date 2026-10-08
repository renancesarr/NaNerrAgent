---
name: clarificar
description: >
  Analisa o prompt antes de qualquer execução: detecta ambiguidades que
  mudam o resultado, oferece 3 opções por ambiguidade, valida o
  entendimento com o usuário. Usar em toda task média (modo leve) ou
  grande (modo completo), após classificação por conter. Não usar em
  triviais.
---

# clarificar

## Objetivo
O retrabalho de interpretar errado custa mais que uma pergunta de 30 segundos.
Esta skill garante que o problema está entendido antes de existir código errado.

## Modos
| Modo | Quando | Como |
|---|---|---|
| leve | task média | só ambiguidades críticas, uma rodada, sem interrogar implícitos |
| completo | task grande | todas as críticas + requisitos implícitos, até validação explícita |

## O que é ambiguidade crítica
Uma ambiguidade só é crítica se as interpretações levam a **código ou teste
diferentes**. Se ambas levam ao mesmo diff, não é ambiguidade — é sinônimo.
Não invente perguntas: interrogação sem propósito gera usuário que para de
responder.

Checklist de detecção:
- termo com 2+ interpretações plausíveis que mudam o que é construído
- escopo indefinido: o que entra, o que fica explicitamente de fora
- métrica de sucesso ausente: como se sabe que deu certo?
- requisito conflitante — com outro requisito ou com ADR existente
- requisito implícito: óbvio para quem pediu, invisível para quem implementa
- pedido colide com unidade no CATALOG.md: criar novo, ou extender/reusar?

## Processo
1. Leia o prompt. Extraia: objetivo, requisitos explícitos, requisitos implícitos.
   Repo tem CATALOG.md? Consulte-o para o último item do checklist.
2. Rode o checklist. Filtre pela criticidade acima.
3. Mais de 3 ambiguidades críticas? Provável sub-classificação — proponha
   reclassificar como grande (via conter) em vez de interrogar em série.
4. Para CADA ambiguidade crítica, gere 3 opções:
   - **1. conservadora** — interpretação mais restrita
   - **2. balanceada** — intermediária
   - **3. abrangente** — mais ampla
   Uma linha por opção, com o custo implícito ("abrangente inclui também X").
5. Apresente o objetivo identificado (para confirmar, não presumir) +
   ambiguidades numeradas + opções + recomendação com por quê.
6. Usuário responde com dígitos ("1,3") — ou delega: "você decide".
   Delegou? Aplique a recomendada e marque como **premissa não validada**.
7. Escolha conflita com ADR existente? Sinalize: a escolha vira decisão nova
   ou emenda — `modelar-dominio` registra no pipeline grande.
8. Reescreva o prompt incorporando as escolhas. Esta é a **versão canônica** —
   o input exato que a próxima skill recebe.
9. Registre a transição (AGENTS.md §6). Campos do LOG desta skill:
   - `prompt-original:` verbatim
   - `prompt-clarificado:` a versão canônica
   - `ambiguidades:` título → opção escolhida
   - `premissas não validadas:` delegações, se houver

## Formato de saída
```
## Entendimento
[objetivo em 1–2 linhas — confirmável]

## Ambiguidade 1: [título]
1. conservadora — [o que muda]
2. balanceada — [o que muda]
3. abrangente — [o que muda]
recomendo: [n], porque [razão em 1 linha]

Responda com os números (ex: "1,3") ou "você decide".

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "Está claro o suficiente" | Formule 2 interpretações que gerem código diferente. Conseguiu? Não está. |
| "Pergunto no meio, se precisar" | Dúvida no meio = retrabalho de código feito; dúvida agora = uma mensagem. |
| "Assumo a interpretação óbvia" | "Óbvia" para quem pediu. No mínimo, premissa não validada no LOG. |
| "O usuário vai se irritar" | Opções numeradas se respondem com um dígito. O que irrita é receber errado. |
| "Pergunto tudo, é mais seguro" | Pergunta que não muda código é ruído. Filtre pela criticidade. |

## Verificação
- Prompt canônico validado por **resposta explícita** — silêncio não é validação —
  ou premissas marcadas como não validadas no LOG.
- Zero ambiguidades críticas restantes listáveis. Achou mesmo zero?
  Registre "zero encontradas" — detecção preguiçosa é achável pelo `auditar`
  quando o código falhar numa ambiguidade que estava no prompt.
- Task com 3+ premissas não validadas: sinal amarelo — o prompt canônico está
  construído sobre areia. Considere uma rodada a mais antes de prosseguir.