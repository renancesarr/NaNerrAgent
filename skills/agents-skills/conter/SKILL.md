---
name: conter
description: >
  Primeira skill de toda task: classifica (trivial/média/grande) ANTES de
  executar, aplica fast path ao trivial e sustenta as leis de contenção
  durante toda execução — escada de reuso, cortes declarados, lista de nunca.
  Não é estágio do pipeline: é a porta de entrada e a lei permanente.
---

# conter

## Objetivo
Burocracia proporcional ao problema. Código mínimo que funciona.
Conter encurta o caminho, nunca o gate. Encurta a solução, nunca a leitura.

## Três momentos, uma filosofia
| Momento | O que faz |
|---|---|
| entrada | classifica a task e escolhe o caminho (AGENTS.md §4) |
| antes do código | escada de reuso — pare no primeiro degrau que segura |
| durante | leis de contenção + cortes declarados |

## A guarda de compreensão
Preguiçoso sobre a solução, NUNCA sobre o entendimento. Leia a task, o código
que ela toca, o fluxo real — e só então suba a escada. O diff pequeno sobre
um problema não-lido não é contenção: é o bug mais caro de todos, o confiante.

## Classificação — hipótese, não veredito

| Classe | Critério | Caminho |
|---|---|---|
| trivial | diff previsto < 10 linhas, sem contrato | fast path (abaixo) |
| média | uma unidade ou um micro | clarificar leve → implementar → verificar-objetivo |
| grande | muda entendimento, várias unidades, decisão | pipeline completo |

Classificar é prever ANTES do diff existir. A realidade pode falsificar a
previsão — e o dever é reclassificar, não agarrar o rótulo inicial.

**Gatilhos de reclassificação (trivial → média), em voo:**
- diff passou de 10 linhas, ou tocou contrato
- passou a tocar 2+ unidades
- descobriu que precisa de implements (roteador)

**Ação:** LOG registra (`classificação ajustada — motivo`), o restante segue
caminho de média, e o fechamento é verificar-objetivo sobre **spec mínima
retroativa** (objetivo + teste, duas linhas). Spec retroativa não é teatro:
é o preço de ter errado o tamanho — e é barato.

**Downgrade** (média → trivial) só com motivo registrado: o trabalho
genuinamente encolheu (já resolvido / one-liner bastava). Downgrades
frequentes seguidos de objetivos quebrados = padrão que o `auditar` caça:
fuga de gate pela porta dos fundos.

## Fast path do trivial
1 linha de LOG (`trivial — motivo`) → diff mínimo → commit.
"Fim" é fim do **pipeline**, não do sistema: gate do commit, `touched` e
sincronia de doc continuam valendo. Toca unidade? Bump de sincronia
(catalogar, 1 linha). **O trivial paga pouco, nunca zero.**
Trivial não passa por `implementar` — descobrir que precisava dele é
reclassificação, não improvisação.

## A escada (antes de escrever código)
Pare no PRIMEIRO degrau que segura:
1. **Precisa existir?** Não → proponha cancelamento ao usuário, motivo em
   uma linha. Confirmou a necessidade? Construa por completo, **sem
   re-argumentar**. A melhor linha de código é a nunca escrita.
2. **Já existe?** CATALOG.md — o índice existe para este degrau custar uma
   leitura, não uma varredura. Re-implementar o que existe alguns arquivos
   abaixo é o slop mais comum.
3. **Stdlib/plataforma resolve?** Use. `<input type="date">` antes de lib
   de picker; constraint de banco antes de código de app.
4. **Dependência já instalada resolve?** Use. Nova dependência = justificativa
   no LOG (e ADR, se cruzar o teste de promoção).
5. **Uma linha resolve?** Uma linha.
6. **Só então:** o código mínimo que funciona.

Duas opções de mesmo tamanho? A correta nos casos de borda.
Preguiça é menos código, não algoritmo mais frágil.

## Leis durante execução
- Sem abstração não pedida: interface com uma implementação não existe;
  factory de um produto não existe; config de valor que nunca muda não existe.
- Deleção > adição. Chato > esperto — esperto é o que alguém decifra às 3h.
  Deleção segue catalogar: doc sai, ponteiros de ADR varridos.
- Bug = causa raiz: grep em TODO caller antes de tocar. Um guard na função
  compartilhada é diff menor que um por caller — e patch só no caminho do
  ticket deixa o irmão quebrado.
- Corte deliberado com teto conhecido → marcador `contencao:`, nunca silêncio.

## contencao: — dívida declarada
Formato: `contencao: [teto conhecido]; migrar quando [gatilho observável]`
Ex.: `contencao: lock global; migrar quando contenção > 5% do tempo de request`
"Quando ficar lento" não é gatilho, é humor. Gatilho sem número não é gatilho.
O `auditar` varre idade e gatilho atingido: corte declarado é dívida visível;
corte em silêncio é bug sem data marcada.

## Nunca contenha
- validação em fronteira de confiança
- tratamento de erro que previne perda de dados
- segurança; acessibilidade básica
- calibração que o mundo físico exige (clocks driftam, sensores leem torto)
- qualquer coisa explicitamente pedida — escolha do usuário vence, sem re-argumentar
- o gate: contenção sem verificação é não-entrega

## Estado ≠ comportamento — a objeção respondida aqui
Conter COMPORTAMENTO, não ESTADO. Código é passivo a conter: cada linha é
manutenção futura. Docs, catálogo, LOG, NOW são o que torna a contenção
possível — é a doc da unidade que faz o degrau 2 custar uma leitura; é o
LOG que evita re-decisão. A doc que previne uma re-implementação tem custo
negativo. Cortar o mapa para economizar papel é alongar todos os caminhos.

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "É só um typo, nem classifico" | A classificação É o fast path: 1 linha. Pulá-la é onde o sistema fura. |
| "Classifico trivial, agiliza" | Trivial é hipótese com critérios. Diff de 80 linhas com label trivial é violação que o auditar acha em segundos. |
| "Leio só o trecho que vou mudar" | Preguiça de leitura não é contenção — é o bug confiante. |
| "Deixo abstrato pra crescer depois" | YAGNI: depois scaffolds para si mesmo. |
| "Faço completo, é mais robusto" | Robustez sem requisito é peso com nome bonito. |
| "Refatoro depois" | Depois é dívida; agora é diff mínimo. |
| "O usuário pediu X, mas dá pra fazer Y" | Pedido explícito vence. Contenção é filosofia de execução, não autoridade sobre pedidos. |

## Verificação
- [ ] Classificação no LOG antes da execução — nunca reconstruída depois.
- [ ] Escada percorrida em ordem, parando no primeiro degrau que segura.
- [ ] Degrau 1 falho → cancelamento proposto, não construção em silêncio.
- [ ] Reclassificação em voo registrada quando a realidade divergiu do previsto.
- [ ] Cortes com `contencao:` têm teto e gatilho observável.
- [ ] Nada da lista de nunca foi contido — nem o gate.
- [ ] Fast path pagou pouco, nunca zero: LOG + touched + sincronia.