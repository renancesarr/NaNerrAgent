---
name: implementar
description: >
  Executa um micro-objetivo do PLAN: consulta IMPLEMENTS-CATALOG.md, seleciona
  1–3 implements-skills para a task, escreve o código, dispara catalogar antes
  do commit e declara arquivos tocados para o gate. É a ÚNICA porta para
  implements-skills. Usar para toda execução de código — de task média ou
  micro do PLAN. Não usar sem spec (não executa o que não está definido).
---

# implementar

## Objetivo
Código com a skill certa do dialeto certo — pagando só pelo que esta task usa.
E código que entra no commit SEMPRE junto da doc e das ADRs que o sustentam.

## As duas leis desta skill
1. **Porta única** (ADR-0002): implementar é o único caminho para uma
   implements-skill. Nenhuma outra skill — nem AGENTS.md — conhece uma delas.
   Consultar o IMPLEMENTS-CATALOG fora daqui é violar a lei da visibilidade.
2. **Sem spec, não executa**: se o micro não tem spec com teste do objetivo
   definido (mesmo rascunho), volte para `decompor`. Código escrito sem
   definição de "pronto" é dívida disfarçada de entrega.

## Sequência interna (ordem importa)
```
1. pegar o micro do PLAN
2. validar spec contra estado real (abaixo)
3. rotear implements
4. escrever código (com implements carregadas)
5. TDD no unitário (forma definida pela implements escolhida)
6. disparar catalogar (unidades tocadas)
7. atualizar PLAN + NOW + LOG
8. commit (com touched declarado)
```

## Passo 2 — validar a spec contra o estado real
A spec foi escrita num momento anterior; o mundo pode ter mudado:
- Micro anterior alterou unidade que esta spec pressupõe intacta?
- ADR foi criada/emendada desde a spec?
- `git status` mostra alteração não registrada no NOW?

Divergência encontrada → ajuste a spec ANTES de escrever código (edite o
PLAN, LOG registra o ajuste e por quê). Spec é o melhor entendimento da
época, não bíblia — mas código escrito contra spec velha é retrabalho duplo:
o código errado + o achado do `verificar-objetivo` que devolve tudo.

## Passo 3 — rotear implements
1. Leia IMPLEMENTS-CATALOG.md do projeto.
2. Para cada entrada, cheque: `usar quando` descreve esta task? `não usar
   quando` a exclui?
3. **0 selecionadas**: é um resultado válido. Registre "nenhuma aplicável
   porque [motivo]" — e catalogue como **candidate** no IMPLEMENTS-CATALOG
   (skill que não existe ainda mas que esta task precisaria).
4. **1–3 selecionadas**: carregue-as. Mais que 3 = sinal de que a task
   está grande demais para uma sessão — considere voltar ao `decompor`.
5. Registe no LOG: `implements: [skills] + por quê cada uma`.

### Por que 1–3 (a lógica, não o número)
Carregar skill tem custo e tem benefício. Uma task bem-decomposta raramente
precisa de mais de 3 dialetos simultâneos (ex.: testar-rust + padroes-api).
Se precisa de 4+, o micro não era micro — era um macro disfarçado.

## Passo 4 — escrever código
Siga as implements carregadas para o dialeto, convenções e padrões do
projeto. Sem implements aplicáveis, siga as leis do AGENTS.md §2 e o
bom senso da linguagem. A implementação segue a spec; divergências
descobertas durante a escrita (impossibilidade técnica, dependência
inesperada) → ajuste a spec primeiro (mesma regra do passo 2), depois
o código.

## Passo 5 — TDD no unitário (higiene interna, AGENTS.md §5)
A implements-skill de testes define a FORMA (framework, padrões, nomes).
A disciplina é fixa: red → green → refactor, na unidade de lógica.
Não escreve unitário para trivial (conter classifica; typo não gera suite).
O gate de entrega é o teste do OBJETIVO — isso é `verificar-objetivo`,
não aqui. Aqui: a unidade funciona isolada e a lógica ramificada
(branches, loops, parsing, money/security) tem check executável.

## Passo 6 — disparar catalogar
Toda unidade tocada precisa de doc sincronizada antes do commit.
`catalogar` cuida do trabalho; aqui basta garantir que ela roda
antes do commit — nunca depois. Sequência fixa: código → catalogar → commit.

## Passo 7 — atualizar PLAN + NOW + LOG
- **PLAN**: micro marcado `concluído` (ou `em-progresso` se quebrou no meio).
- **NOW**: reescrito — próximo micro como "próximo passo imediato";
  se quebrou no meio, o estado parcial (o que foi feito, o que falta,
  onde exatamente parou).
- **LOG**: entrada com `micro`, `implements + por quê`, `diff resumido`
  (1–3 linhas, não o diff inteiro — o git já tem), `sincronia` (o que
  catalogar declarou).

## Passo 8 — commit
1. Declare os arquivos que o commit vai conter em `.context/touched`
   (unidades + docs + PLAN + NOW + LOG — tudo que vai no commit).
2. Commit. O pre-commit compara staged vs touched (AGENTS.md §7).
3. Divergência = bloqueio. Se o agente esqueceu de declarar algo,
   ajuste `touched` e re-commit. Não contorne o gate.

## Micro que não cabe numa sessão
Estourou o tempo/contexto no meio? Não force terminar. Registre no NOW:
- o que está feito (unidades, diff parcial)
- o que falta (passos restantes da spec)
- onde exatamente parou (não "no meio" — o próximo passo concreto)

O próximo agente retoma pelo NOW. Um micro bem-decomposto mal-executado
é recuperável; um micro forçado no fim da sessão é código possivelmente
quebrado com cara de pronto.

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "Carrego todas as implements, é mais seguro" | É o modo-ECC: tudo disponível sempre = agente perdido sempre. A seleção explícita é o design. |
| "Spec velha, sigo mesmo assim" | Código contra spec velha = retrabalho duplo. Ajustar spec custa 2 linhas no PLAN. |
| "Catalogar depois do commit" | O gate bloqueia. E se não bloqueasse: doc depois é doc nunca. |
| "Termino o micro, está quase" | Quase = não está. Estado parcial no NOW é recuperável; quebrado com cara de pronto não é. |
| "Uma implement extra não faz mal" | Cada skill carregada é contexto que compete com a task. Se não foi selecionada com por quê, não entra. |

## Verificação
- [ ] Spec validada contra estado real antes do código (LOG registra ajuste ou "sem divergência").
- [ ] Seleção de implements registrada com justificativa por skill (ou "nenhuma porque...").
- [ ] Toda unidade do commit tem doc sincronizada (catalogar rodou antes do commit).
- [ ] `.context/touched` declara tudo que foi commitado (o gate passa).
- [ ] NOW reescrito: próximo micro ou estado parcial explícito.
- [ ] LOG tem entrada com micro, implements, diff resumido, sincronia.