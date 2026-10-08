# IDEIA.md

## O problema

Todo desenvolvedor que usa agentes de código (Codex, OpenCode, ZCode) enfrenta os
mesmos cinco problemas, em toda linguagem:

1. **O agente não sabe o que já existe** — queima tokens relendo código para
   descobrir o que poderia ter achado num índice.
2. **O prompt ambíguo vira código errado** — o retrabalho de interpretar errado
   é mais caro que uma pergunta de 30 segundos antes.
3. **Documentação apodrece** — doc desatualizada é pior que doc inexistente,
   porque o agente confia nela.
4. **O contexto morre com a sessão** — compactação, crash, máquina nova:
   tudo que o agente "sabia" evaporou, e a qualidade cai sem ninguém saber onde.
5. **Edição humana é um buraco negro** — o humano mexe no código fora do fluxo,
   o porquê da mudança nunca é capturado, e vira arqueologia no próximo bug.

Nenhum dos frameworks existentes resolve os cinco. A maioria resolve um ou dois
e adiciona os seus próprios (burocracia, 293 skills que ninguém navega, TDD
obrigatório em typo).

## A ideia em uma frase

**Um conjunto pequeno e fixo de agent-skills que faz o agente trabalhar com
estado fora da conversa: catálogos indexam o que existe, ADRs registram por que
existe, NOW/LOG registram onde a execução está — e toda mudança, inclusive a
humana, é obrigada a manter esse estado verdadeiro.**

## O que é

- Um conjunto de **9 agent-skills nucleares, fixas, agnósticas de linguagem**
  (Python, TypeScript, Java, Go, Zig, Rust), que sempre estaram presentes. E deve ser carregada apenas a agents-skill atual.
- Um **protocolo transversal (context-now)** que atravessa todas as skills:
  escreve sempre, lê sob demanda.
- Um **roteador de implementação**: as skills específicas de projeto
  (implements-skills) são invisíveis por padrão; só a skill `implementar`
  as conhece, via catálogo, e carrega apenas as 1–3 úteis para a task atual.
- Um **gate determinístico no pre-commit** que transforma toda edição humana
  em conhecimento capturado.
- Projetado para **Codex, OpenCode e ZCode** — três CLIs similares, um sistema.

## O que NÃO é

- Não é framework de mercado, não é plugin para 15 harnesses.
- Não é TDD-first: o teste do **objetivo** é o gate (estilo QA); o unitário é
  TDD à risca mas é higiene interna.
- Não é DDD formal: linguagem ubíqua e ADRs sim; bounded contexts e agregados não.
- Não é "uma função por arquivo": é **uma unidade coesa por arquivo** — um
  conceito, um motivo para mudar (anti-idiomático seria o contrário em Go/Rust).
- Não é ECC: nada de centenas de skills sempre disponíveis. Núcleo pequeno +
  per-iférico declarado. Se não está no setup, o agente não usa.

## Os nove mecanismos

| # | Mecanismo | O que faz |
| 1 | Taxonomia 3 camadas | agent (fixas) / implements (por projeto, invisíveis)|
| 2 | Catálogo de código | índice de 1 linha por unidade + doc de contexto ao lado de cada arquivo |
| 3 | Catálogo de ADRs | decisões com vínculo bidirecional às unidades; mudança obriga sincronização |
| 4 | Clarificação de prompt | ambiguidades detectadas → 3 opções (conservadora/balanceada/abrangente) |
| 5 | Decomposição | checkpoint → macro → micro, cada micro com spec e teste do objetivo |
| 6 | Verificação QA-first | gate de entrega = comportamento do objetivo com evidência executável |
| 7 | context-now | NOW (snapshot ≤100 linhas) + LOG (append-only); retomada sem cache LLM |
| 8 | Gate humano | pre-commit determinístico exige porquê de edição fora do fluxo |
| 9 | Contenção + fast path | trivial/média/grande classificado ANTES; trivial não paga pipeline |

## Genealogia — composição honesta

| Fonte | Tomamos | Ajustamos | Rejeitamos |
| Matt Pocock | grilling, glossário, ADRs, to-spec/to-tickets | ADRs agrupadas em catálogo com vínculo obrigatório | granularidade excessiva (40 ADRs = não-decisões) |
| Superpowers | pipeline de entendimento, decomposição, execução por task | gate vira QA-first, não TDD-first | TDD estrito como centro |
| Agent Skills (Addy) | disciplina de verificação, tabelas anti-racionalização, evidência obrigatória | aplicadas ao objetivo, não só ao unitário | viés web/frontend |
| Ponytail | contenção, fast path, escada de reuso (YAGNI/stdlib/1 linha) | com as nossas leis dentro | "fewest files possible" contra unidade coesa |
| ECC | pontos seletos de organização | — | o modo-ECC: tudo disponível sempre = agente perdido |
| OpenDesign | — | — | é workspace de design, não metodologia |

## O que é genuinamente novo aqui

1. **O catálogo como índice de contexto central** — o agente descobre o que
   existe lendo um índice, não o código. Nenhum framework famoso tem isso como
   peça central.
2. **A assimetria do context-now** — escreve sempre (caro uma vez, não polui a
   janela), lê em 3 gatilhos cirúrgicos (cold start, pós-compaction,
   auditoria). É um write-ahead log aplicado a agente.
3. **O gate humano** — a edição manual não é tolerada nem detectada tardiamente:
   é convertida em conhecimento (porquê + conceito + como) no único momento
   em que a memória do porquê existe: antes do commit.

## Princípios norteadores

- **Unidade coesa**: se não dá pra nomear o arquivo com o nome do único
  conceito dele, ele faz coisa demais. 50–150 linhas como guia.
- **DRY radical**: cada conhecimento tem UMA representação autoritativa;
  catálogo aponta, nunca duplica.
- **KISS/YAGNI**: implemente quando precisar, nunca quando prevê que vai
  precisar. Burocracia proporcional ao problema.
- **SOLID traduzido** para linguagens não-OO: um motivo para mudar (S),
  variantes sem tocar consumidores (O), contratos honrados (L), interfaces
  pequenas (I), dependências passadas (D).
- **O teto do NOW é diagnóstico**: estourou 100 linhas → a decomposição
  falhou, não a documentação. Volte uma etapa.
- **Evidência > afirmação**: "parece certo" nunca é critério; comando + saída sim.

## Ambiente-alvo

- **CLIs**: Codex, OpenCode, ZCode.
- **Linguagens**: Python, TypeScript, Java, Go, Zig, Rust — o que varia por
  linguagem (layout, doc nativa, testes) mora em implements-skills declaradas
  no setup do projeto; o que é universal mora no núcleo.
- **Critério de classificação de skill**: sobrevive a um repo vazio →
  agent-skill. Precisa de código pra existir → implements-skill.

## Como saber que funciona

Três métricas, medidas antes vs. depois, em uso real:

1. Tempo até o agente **encontrar** código/decisão existente.
2. Taxa de documentação **desatualizada** ao fim de cada semana.
3. Retrabalho por **entendimento errado** (objetivo entregue ≠ pedido).

E um instrumento de graça: quando a qualidade cair, `auditar` lê o LOG em
sequência e aponta a transição exata onde a execução degradou — com evidência,
não palpite.

## Estado atual

- Design completo, acordado em 6 rodadas de clarificação: ADRs 0001–0010.
- Artefatos de bootstrap escritos: AGENTS.md, 9 skills, catálogos, hook, NOW, LOG.
- **Zero horas de uso real.** A diferença entre este projeto e os que deram
  certo não está nas ideias — está nas cicatrizes de produção, que ainda não
  existem. O LOG vai gerá-las.

## Próximo passo

Instalar nos 3 CLIs e executar a primeira task real num repositório de
verdade. A partir daí, o sistema se valida (ou se corrige) pelo próprio LOG.
```

---

Entregue a IDEIA.md — contida, cada seção muda decisão de quem lê, sem repetir o que o ADR-CATALOG já indexa.

**A fila, na ordem que proponho:**

1. ✅ IDEIA.md *(este)*
2. AGENTS.md *(as leis — já escrito na rodada anterior, reviso e reenvio)*
3. As 9 skills, uma por mensagem
4. Catálogos (CATALOG / ADR-CATALOG / IMPLEMENTS-CATALOG) + ADR exemplo
5. `hooks/pre-commit` + `.context/` (NOW, LOG, pending-human, touched)

Confirmo o AGENTS.md como próximo?