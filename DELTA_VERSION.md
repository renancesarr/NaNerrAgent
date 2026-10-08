Dogfood. O que isso implica em três pontos, antes dos artefatos:

1. **Esta conversa inteira foi a etapa `clarificar` + `modelar`** — logo, ela vira a primeira entrada do LOG e as decisões que fechamos viram os ADRs-0001 a 0010 do meta-repo
2. **Cada skill é uma unidade coesa** — logo, o próprio CATALOG.md do repo cataloga as 9 skills que o compõem
3. **A primeira execução real do NOW.md já existe** — refletindo exatamente onde estamos: artefatos de bootstrap criados, próxima etapa = instalação e primeira task real

E aplicando `conter` a esta resposta em si: cada skill fica entre 70–90 linhas, o protocolo context-now é definido **uma vez** no AGENTS.md e apenas referenciado nas skills (DRY), e os ADRs ficam em catálogo + 1 exemplo completo.

## Estrutura do Repo

```
.
├── AGENTS.md                    # as leis. carregado sempre. ~130 linhas
├── CATALOG.md                   # catálogo das unidades (as 9 skills)
├── ADR-CATALOG.md               # índice das decisões
├── IMPLEMENTS-CATALOG.md        # vazio no bootstrap — o meta-repo não tem dialeto ainda
├── docs/adr/
│   ├── 0001-unidade-coesa.md    # exemplo completo; 0002–0010 seguem o template
│   └── ...
├── skills/
│   ├── clarificar/SKILL.md
│   ├── decompor/SKILL.md
│   ├── modelar-dominio/SKILL.md
│   ├── catalogar/SKILL.md
│   ├── implementar/SKILL.md
│   ├── verificar-objetivo/SKILL.md
│   ├── conter/SKILL.md
│   ├── capturar-humano/SKILL.md
│   └── auditar/SKILL.md
├── hooks/
│   └── pre-commit               # gate determinístico
└── .context/
    ├── NOW.md                   # snapshot atual
    ├── touched                  # arquivos declarados pelo agente (o hook lê)
    ├── pending-human.md         # template do porquê humano
    └── log/
        └── 001-clarificar.md    # esta conversa
```

---

## AGENTS.md

````markdown
# AGENTS.md — Agente de Desenvolvimento com Contexto Persistente

Você trabalha com estado fora da conversa: catálogos indexam o que existe,
ADRs registram por que existe, NOW/LOG registram onde a execução está.
Nada de importante vive só na sua memória de sessão.

## 1. Leis

1. **Unidade coesa**: um arquivo = um conceito = um motivo para mudar.
   Se não consegue nomear o arquivo com o nome do único conceito dele, ele faz coisa demais. Guia: 50–150 linhas.
2. **DRY**: cada conhecimento tem UMA representação autoritativa. Catálogo aponta; não duplica.
3. **KISS / YAGNI**: implemente quando precisar, nunca quando prevê que vai precisar. Sem abstração não pedida, sem dependência nova evitável, stdlib antes de custom.
4. **SOLID traduzido**: um motivo para mudar (S) · variantes novas sem tocar consumidores (O) · contratos honrados (L) · interfaces pequenas (I) · dependências passadas, não globais (D).
5. **Documentação obrigatória**: toda unidade tem seu `.md` de contexto. Unidade sem doc ou doc sem unidade = commit bloqueado.
6. **Bug = causa raiz**: grep todo caller antes de tocar. Patch no sintoma deixa o irmão quebrado.

## 2. Skills — taxonomia e visibilidade

| Camada | Quem conhece | Exemplo |
|---|---|---|
| `agent-skills/` (9) | sempre carregadas | clarificar, decompor, modelar-dominio, catalogar, implementar, verificar-objetivo, conter, capturar-humano, auditar |
| `implements-skills/` | **só `implementar`**, via IMPLEMENTS-CATALOG.md | testar-rust, padroes-api-go |
| `platform-skills/` | só quando a task é de deploy | vercel, cloudflare |

**Lei da visibilidade**: `implementar` é a ÚNICA porta para implements-skills.
AGENTS.md não conhece nenhuma. Seleção registrada no LOG com justificativa.

**Critério de classificação**: sobrevive a um repo vazio → agent-skill.
Precisa de código para existir → implements-skill.

## 3. Pipeline com fast path

Classifique ANTES de executar (`conter`):

| Classe | Critério | Caminho |
|---|---|---|
| trivial | diff < 10 linhas, sem mudança de contrato | diff mínimo, 1 entrada de LOG, ponto |
| média | uma unidade ou uma task | clarificação leve → task → verificação |
| grande | muda entendimento ou várias unidades | pipeline completo |

Pipeline completo: `clarificar` → `decompor` → (`modelar-dominio` se houver decisão) → `implementar` → `verificar-objetivo`. Toda etapa termina com registro context-now (§5). Sem exceção.

## 4. Verificação — QA-first

O **teste do objetivo** é o gate: como um QA testaria? Comportamento, integração, aceitação. A forma varia por projeto (declareda em implements-skills); a exigência é fixa.

Unitário segue TDD à risca, mas é higiene interna.
PR com unitário verde e objetivo quebrado = REPROVADO.
Entrega exige evidência executável, nunca afirmação.

## 5. Protocolo context-now

```
.context/
├── NOW.md      # snapshot, reescrito a cada transição, teto 100 linhas
└── log/NNN-*.md  # append-only, nunca reescreve o passado
```

**Escrita é obrigatória e sempre** (via tool de arquivo — não polui a janela).
**Leitura é sob demanda, em 3 gatilhos**: (1) cold start com NOW em-progresso;
(2) pós-compaction ou quando a confiança no estado cair; (3) auditoria/rota, via catálogo de objetivos.

**Regra de linha**: entra no NOW se, e somente se, muda uma decisão futura.

**Teto do NOW = instrumento de diagnóstico**: estourou 100 linhas → a decomposição falhou, volte uma etapa. Não escreva um NOW maior.

**Retomada**: ler NOW → última entrada do LOG → conferir contra `git status` e artefatos reais. Divergência → re-validar a etapa, nunca retomar cego.

## 6. Commits e edições humanas

- Commit que toca unidade toca (ou declara inalterada) a doc dela e as ADRs vinculadas, no mesmo commit.
- O hook `hooks/pre-commit` compara staged vs `.context/touched`. Divergência exige `.context/pending-human.md` preenchido (porquê + conceito). Sem isso, commit bloqueado.
- Na próxima sessão, `capturar-humano` expande o pending em entrada completa do LOG.

## 7. Fast path do trivial

Typo, cor, renome local, lockfile: diff mínimo, uma linha no LOG, sem cerimônia.
Burocracia em tarefa trivial é o jeito mais rápido de ódio ao processo.
````

---

## As 9 Skills

### skills/clarificar/SKILL.md

````markdown
---
name: clarificar
description: >
  Analisa o prompt antes de qualquer execução. Detecta ambiguidades e sugere
  3 opções de ajuste por ambiguidade. Usar ao receber qualquer task nova
  classificada como média ou grande. Não usar em triviais (ver conter).
---

# clarificar

## Objetivo
Garantir que o problema está entendido antes de existir código errado.

## Processo
1. Leia o prompt. Extraia: objetivo principal, requisitos explícitos, requisitos implícitos.
2. Detecte ambiguidades: termos vagos, escopo indefinido, métrica de sucesso ausente, requisitos conflitantes.
3. Para CADA ambiguidade, gere 3 opções:
   - **conservadora** — interpretação mais restrita
   - **balanceada** — intermediária
   - **abrangente** — mais ampla
4. Apresente objetivo identificado + ambiguidades + opções + sua recomendação (uma por ambiguidade).
5. Aguarde escolha. Reescreva o prompt com as escolhas incorporadas.
6. Terminou: registra transição (AGENTS.md §5). Campos específicos no LOG:
   `prompt-original`, `prompt-clarificado`, `ambiguidades + opções escolhidas`.

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "Está claro o suficiente" | Consegue formular 2 interpretações? Então não está. |
| "Pergunto no meio se precisar" | Dúvida no meio custa retrabalho; dúvida agora custa uma mensagem. |
| "O usuário vai achar chato" | 3 opções numeradas respondem-se com um dígito. |

## Verificação
Prompt reescrito validado pelo usuário (resposta explícita, não silêncio).
Zero ambiguidades restantes listáveis.
````

### skills/decompor/SKILL.md

````markdown
---
name: decompor
description: >
  Divide objetivo clarificado em checkpoint → macro-objetivo → micro-objetivo.
  Cada micro vira uma task com especificação e critério verificável.
  Usar após clarificar em tasks médias/grandes.
---

# decompor

## Objetivo
Nenhuma task maior que uma sessão. Nenhum NOW que estoure o teto.

## Estrutura
- **checkpoint** — macro-entregável (semanas)
- **macro-objetivo** — componente do checkpoint (1–2 semanas)
- **micro-objetivo** — task atômica (horas, uma sessão, um passo do NOW)

## Processo
1. Do prompt clarificado, liste os checkpoints.
2. Quebre cada checkpoint em macro-objetivos.
3. Quebre cada macro em micros. Para cada micro, escreva a spec:

```markdown
# [nome do micro]
objetivo: [1–2 linhas]
critérios: [ ] ... [ ] ...        ← verificáveis de forma independente
dependências: [micros anteriores ou —]
unidades: [arquivos a criar/alterar, se conhecidos]
teste do objetivo: [como um QA validaria ESTE micro]
```

4. Priorize: valor primeiro, risco cedo, dependências respeitadas.
5. Terminou: registra transição. LOG recebe: `checkpoints`, `macros`, `specs dos micros` (ou apontamento para onde foram salvas). NOW recebe o primeiro micro como "próximo passo imediato".

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "É simples, vou direto" | Simples não precisa de decomposição — reclassifique como trivial via `conter`. |
| "Decompo conforme avança" | Cada fronteira movida no meio custa re-trabalho em tudo que já encostou nela. |

## Verificação
Cada micro tem critério verificável sem depender de outro micro.
Contagem de micros × tamanho estimado não estoura o teto do NOW quando descritos.
````

### skills/modelar-dominio/SKILL.md

````markdown
---
name: modelar-dominio
description: >
  Mantém o glossário (linguagem ubíqua) e as ADRs do projeto.
  ADR = decisão com trade-off duradouro, nada menos.
  Usar quando uma task muda uma decisão de domínio ou introduz termo novo.
---

# modelar-dominio

## Objetivo
Termo significa uma coisa só. Decisão com trade-off tem endereço.

## Regra de granularidade (a mais importante desta skill)
- **ADR**: decisão de domínio com trade-off duradouro (escolha entre alternativas com consequência).
- **Comentário no código / linha no doc da unidade**: micro-decisão técnica.
- Se você tem 40 ADRs num sistema pequeno, alguém está documentando não-decisões.

## Processo — glossário
1. Termo novo ou usado de forma inconsistente? Uma entrada em GLOSSARY.md:
   `**termo** — definição em uma linha.`
2. Termo não usado em lugar nenhum do código/doc? Marque órfão, proponha remoção.

## Processo — ADR
1. Detectou decisão com trade-off? Crie `docs/adr/NNN-slug.md`:
```markdown
---
id: NNN
status: aceita
supersedes: —
unidades: [caminhos das unidades que a sustentam]
---
# [decisão em uma frase]
## contexto
[que pressão motivou]
## alternativas
[as consideradas, com contra]
## consequências
[o que ganhamos, o que abrimos mão]
```
2. Adicione a linha no ADR-CATALOG.md.
3. Vínculo bidirecional: a ADR lista `unidades`; cada unidade lista `decisions` no frontmatter do seu `.md` (`catalogar` cuida do outro lado).
4. Terminou: registra transição. LOG: `ADR criada/emendada + por quê`.

## DDD-lite — onde para
Sim: linguagem ubíqua, decisões rastreáveis, fronteiras por domínio.
Não: bounded contexts formais, agregados, cerimônia. CRUD é CRUD.

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "Decido e documento depois" | Depois nunca chega; a decisão vira arqueologia no próximo bug. |
| "É detalhe técnico, não ADR" | Então é comentário no código. Confirme a granularidade, não pule o registro. |

## Verificação
ADR sem campo `alternativas` = inválida.
Termo do glossário usado com 2 significados no código = falha desta skill.
````

### skills/catalogar/SKILL.md

````markdown
---
name: catalogar
description: >
  Mantém CATALOG.md (índice de unidades) e o .md de contexto de cada unidade,
  com vínculo bidirecional às ADRs. Usar ao criar/alterar qualquer unidade.
---

# catalogar

## Objetivo
O agente descobre o que existe lendo um índice, não o código inteiro.

## Processo
1. Unidade nova (ou alterada) → o `.md` ao lado dela:

```markdown
---
unidade: caminho/arquivo.ext
decisions: [ADR-NNN, ...]
última-sincronia: <hash do commit>
---
# [nome]
responsabilidade: [1–2 frases]
interface: [o que é público, assinatura mínima]
dependências: [unidades e ADRs]
exemplo: [uso mínimo real]
notas: [o que o próximo leitor precisa saber e não vê na assinatura]
```

2. Uma linha no CATALOG.md: `| caminho | responsabilidade em 1 linha |`
3. Vínculo ADR: frontmatter `decisions` ↔ campo `unidades` da ADR.
4. Alterou a unidade sem mudar contrato? Atualize `última-sincronia`, declare "contrato inalterado".
5. Terminou: registra transição. LOG: `unidades tocadas + docs correspondentes`.

## Regras de sincronia
- Commit que toca `X` toca `X.md` (ou declara contrato inalterado). Sem exceção.
- Unidade sem doc = commit bloqueado (o mesmo gate do pre-commit).
- ADR órfã (sem unidades) = aviso na próxima auditoria.

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "Arquivo pequeno, se explica" | O catálogo é para o agente que NUNCA abriu este arquivo. |
| "Atualizo a doc no final" | Final de quê? Cada commit é um estado válido ou não é. |

## Verificação
CATALOG.md sem linha para a unidade criada = skill não executada.
Frontmatter sem decisions quando o domínio tem ADRs aplicáveis = vínculo furado.
````

### skills/implementar/SKILL.md

````markdown
---
name: implementar
description: >
  Executa um micro-objetivo. ÚNICA porta para implements-skills: consulta
  IMPLEMENTS-CATALOG.md, seleciona 1–3 para a task, carrega só o necessário.
  Usar para toda execução de código.
---

# implementar

## Objetivo
Código com a skill certa do dialeto certo, pagando só pelo que esta task usa.

## Processo
1. Pegue o micro do NOW. Confira a spec (objetivo, critérios, unidades, teste do objetivo).
2. Leia IMPLEMENTS-CATALOG.md. Selecione 1–3 skills com: `usar quando` batendo com a task.
   Nenhuma bate? Prossiga sem — cataloga a lacuna como candidate.
3. Carregue SÓ as selecionadas. Execute o micro seguindo-as.
4. Antes do commit: declare os arquivos tocados em `.context/touched`
   (o pre-commit compara contra isso — AGENTS.md §6).
5. Unitário: TDD à risca nas unidades de lógica (a skill implements escolhida define a forma).
6. Terminou: registra transição. LOG: `micro executado`, `implements selecionadas + POR QUÊ`,
   `diff resumido`. NOW: próximo micro como "próximo passo imediato".

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "Carrego todas as implements, é mais seguro" | É o modo-ECC: tudo disponível sempre = agente perdido sempre. |
| "Não sei qual serve, leio duas inteiras" | O catálogo tem `usar quando` para exatamente isso. Se não tem, o catálogo está ruim — conserte-o. |

## Verificação
Seleção de implements registrada no LOG com justificativa (ausência também é registro: "nenhuma aplicável porque...").
Arquivos do commit ⊆ arquivos declarados em `.context/touched`.
````

### skills/verificar-objetivo/SKILL.md

````markdown
---
name: verificar-objetivo
description: >
  Valida o objetivo/micro como um QA testaria: comportamento, integração,
  aceitação. É o GATE de entrega — não TDD unitário, que é higiene interna.
  Usar ao fechar todo micro e todo objetivo.
---

# verificar-objetivo

## Objetivo
Provar que o que foi pedido aconteceu. Com evidência executável.

## Processo
1. Releia a spec do micro: o campo `teste do objetivo` diz COMO validar.
   Campo vazio? A spec está incompleta — volte ao `decompor`, não invente o teste agora.
2. Execute o teste do objetivo. Registre: comando, saída, resultado.
3. Checklist de rejeição (qualquer um reprova):
   - [ ] objetivo testado como comportamento, não como "código parece certo"
   - [ ] caminhos de erro exercitados (entrada inválida, limite, vazio)
   - [ ] integração entre unidades do micro exercitada, não só unidades isoladas
   - [ ] evidência é reproduzível (comando + saída registrados no LOG)
4. Falhou? Não entregue. Registre a falha no LOG, corrija, re-execute. Loop até verde.
5. Passou? Terminou: registra transição. LOG: `teste executado + evidência`.
   NOW: micro marcado concluído.

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "Unitários todos verdes" | Unitário verde + objetivo quebrado = REPROVADO. Hierarquia no AGENTS.md §4. |
| "Testar objetivo é caro" | Mais caro é descobrir no usuário. |
| "Vou validar manual depois" | "Depois" é onde objetivos vão morrer. |

## Verificação
Entrada de LOG com comando + saída real. Sem isso, o micro NÃO está concluído, independentemente do que o resto diz.
````

### skills/conter/SKILL.md

````markdown
---
name: conter
description: >
  Classifica a task (trivial/média/grande) ANTES de executar e aplica o fast
  path ao trivial. Contém over-engineering durante toda execução.
  Primeira skill a rodar em qualquer task.
---

# conter

## Objetivo
Burocracia proporcional ao problema. Código mínimo que funciona.

## Classificação (antes de tudo)
| Classe | Critério | Caminho |
|---|---|---|
| trivial | diff < 10 linhas, sem mudança de contrato | diff mínimo, 1 linha de LOG, sem pipeline |
| média | uma unidade ou um micro | clarificar leve → implementar → verificar |
| grande | muda entendimento, várias unidades, decisão de domínio | pipeline completo |

## Escada de contenção (antes de escrever código, em ordem)
1. Precisa existir? (YAGNI — necessidade especulativa não existe)
2. Já existe no catálogo? Reuse.
3. Stdlib/plataforma resolve? Use.
4. Dependência já instalada resolve? Use. Nova dependência = justificativa no LOG.
5. Uma linha resolve? Uma linha.
6. Só então: código mínimo que funciona.

## Leis durante execução
- Sem abstração não pedida; interface com 1 implementação não existe.
- Deleção > adição. Chato > esperto (esperto é o que alguém decifra às 3h).
- Bug = causa raiz: grep todo caller antes de tocar.
- Corte de canto deliberado com teto conhecido? Comente: `contencao: [teto], migrar quando [gatilho]`.

## Nunca contenha
Validação em fronteira de confiança, tratamento que evita perda de dados,
segurança, acessibilidade básica, qualquer coisa explicitamente pedida.

## Terminou: registra transição. LOG: `classificação + racional em 1 linha`.

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "Vou fazer completo, é mais robusto" | Robustez sem requisito é peso com nome bonito. |
| "Depois refatoro" | Depois é dívida; agora é diff mínimo. |

## Verificação
Classificação registrada no LOG ANTES da execução (não reconstruída depois).
````

### skills/capturar-humano/SKILL.md

````markdown
---
name: capturar-humano
description: >
  Processa edições humanas fora do fluxo: lê o porquê e o conceito de
  .context/pending-human.md, analisa o diff, gera o "como foi feito",
  registra no LOG como conhecimento e reconcilia o NOW.
  Roda no início de toda sessão que encontra pending preenchido.
---

# capturar-humano

## Objetivo
Edição humana entra no fluxo como conhecimento capturado, não como buraco negro.

## Processo
1. Cold start: existe `.context/pending-human.md` com `porque:` e `conceito:` preenchidos?
   Não existe/não preenchido → nada a fazer (o gate do hook cuida da obrigatoriedade).
2. Leia o porquê e o conceito. Obtenha o diff real do commit correspondente.
3. Gere o "como foi feito": o que a edição faz tecnicamente, conectado ao porquê.
4. Escreva entrada no LOG:
```markdown
# NNN — capturar-humano (origem: edição manual)
quando: [timestamp do commit]
porque: [o que o humano escreveu, verbatim]
conceito: [a ideia por trás, verbatim]
como: [gerado pela IA a partir do diff, conectando técnica ao porquê]
unidades afetadas: [do diff]
impacto no NOW: [nenhum | ajuste feito]
```
5. Reconcilie: a edição invalida decisão de domínio? → `modelar-dominio` (emenda ou nova ADR).
   Invalida docs de unidade? → `catalogar`. Muda o próximo passo? → reescreva o NOW.
6. Limpe pending-human.md e `.context/touched` (estado consumido).
7. Terminou: esta skill É uma transição — a entrada acima é o registro.

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "Diff pequeno, não precisa capturar" | O diff pequeno com o porquê errado é o bug caro. O custo é ler 2 linhas. |
| "Só sincronizo o NOW" | Sem o porquê, a edição vira mistério permanente — arqueologia na próxima auditoria. |

## Verificação
Entrada de LOG com os 3 campos (porque verbatim, conceito verbatim, como gerado).
NOW reconciliado ou declarado sem impacto.
````

### skills/auditar/SKILL.md

````markdown
---
name: auditar
description: >
  Diagnóstico sob demanda quando a qualidade cai: lê o LOG em sequência,
  encontra a transição onde a execução degradou, reporta com evidência.
  Também varre unidades sem doc, ADRs órfãs, termos órfãos.
  Invocada explicitamente — nunca automática.
---

# auditar

## Objetivo
Responder "onde o processo falhou" com linha do LOG na mão, não com palpite.

## Processo
1. Leia o LOG do objetivo em ordem. Para cada transição, confira:
   - input declarado era o que a skill recebeu de fato (contra artefatos)?
   - output declarado foi produzido (contra git/artefatos)?
   - campos obrigatórios presentes (implements+porquê, evidência de teste, classificação ANTES)?
2. Varreduras estruturais:
   - unidades sem `.md` ou com `última-sincronia` atrás do commit
   - ADRs órfãs (sem unidades) e unidades com `decisions` apontando ADR inexistente
   - termos do GLOSSARY sem uso; uso de termos fora do glossário
   - NOW acima do teto (→ decomposição falhou)
3. Reporte, por achado: **gravidade · evidência (arquivo+linha/entrada do LOG) · causa provável · correção mínima**.
4. Não corrija no mesmo fôlego (a menos que seja trivial): auditoria é diagnóstico.
5. Terminou: registra transição. LOG: `achados + gravidades`. O relatório vira arquivo em `docs/auditorias/`.

## Pergunta-guia
"O que a skill N recebeu vs. o que produziu — em qual transição a divergência começou?"
A primeira divergência é o local da falha; tudo depois é cascata.

## Verificação
Cada achado cita entrada específica do LOG ou arquivo+linha.
Achado sem evidência citável não é achado, é opinião.
````

---

## Artefatos de Bootstrap

### ADR-CATALOG.md

```markdown
# ADR-CATALOG

| ID | Status | Decisão (1 linha) | Unidades |
|----|--------|-------------------|----------|
| 0001 | aceita | Responsabilidade única por unidade coesa, não por função/arquivo | todas as skills |
| 0002 | aceita | Taxonomia 3 camadas; implementar é a única porta para implements | implementar, AGENTS.md |
| 0003 | aceita | Catálogo + doc por unidade como índice de contexto do agente | catalogar, CATALOG.md |
| 0004 | aceita | ADRs com vínculo bidirecional e atualização obrigatória no mesmo commit | modelar-dominio, catalogar |
| 0005 | aceita | QA-first: teste do objetivo é o gate; TDD unitário é higiene | verificar-objetivo |
| 0006 | aceita | context-now: NOW+LOG; escreve sempre, lê sob 3 gatilhos | protocolo, todas |
| 0007 | aceita | Gate humano determinístico no pre-commit + enriquecimento adiada | capturar-humano, hooks/pre-commit |
| 0008 | aceita | Fast path obrigatório ao trivial | conter |
| 0009 | aceita | Teto do NOW como diagnóstico de decomposição | protocolo, decompor |
| 0010 | aceita | DDD-lite: linguagem ubíqua sim, cerimônia formal não | modelar-dominio |
```

### docs/adr/0001-unidade-coesa.md (as demais seguem este template)

```markdown
---
id: 0001
status: aceita
supersedes: —
unidades: [skills/*/SKILL.md, AGENTS.md]
---
# Responsabilidade única por unidade coesa, não por função por arquivo

## contexto
A proposta original exigia "uma função por arquivo". Em Go e Rust isso é
anti-idiomático e gera explosão de navegação. O objetivo real era
rastreabilidade e localização rápida, não contagem de arquivos.

## alternativas
- Uma função/arquivo literal: rejeitada — anti-idiomática em Go/Rust, piora navegação.
- Sem regra estrutural: rejeitada — agentes perdem tempo relendo código para achar conceitos.

## consequências
Ganhamos: rastreabilidade agnóstica de linguagem, docs concisas, testes focados.
Abrimos mão: enforcement mecânico simples — "coeso" exige julgamento no review.
O julgamento tem régua: nome do arquivo = nome do único conceito; 50–150 linhas.
```

### CATALOG.md

```markdown
# CATALOG — unidades

| Unidade | Responsabilidade |
|---|---|
| AGENTS.md | leis, taxonomia de skills, pipeline, protocolo context-now |
| skills/clarificar | detecta ambiguidades do prompt, 3 opções, valida entendimento |
| skills/decompor | quebra objetivo em checkpoint→macro→micro com spec verificável |
| skills/modelar-dominio | glossário + ADRs com granularidade correta e vínculo |
| skills/catalogar | índice de unidades + doc de contexto + vínculo bidirecional |
| skills/implementar | roteia implements-skills e executa o micro |
| skills/verificar-objetivo | gate QA-first com evidência executável |
| skills/conter | classificação trivial/média/grande + contenção + fast path |
| skills/capturar-humano | converte edição humana em conhecimento no LOG |
| skills/auditar | diagnóstico de degradação com evidência do LOG |
| hooks/pre-commit | gate determinístico: divergência exige porquê |
```

### hooks/pre-commit

```bash
#!/usr/bin/env bash
# ADR-0007: gate determinístico. Enriquecimento LLM é adiada (capturar-humano).
set -euo pipefail

TOUCHED=".context/touched"
PENDING=".context/pending-human.md"
STAGED=$(git diff --cached --name-only)

[ -z "$STAGED" ] && exit 0

if [ -f "$TOUCHED" ]; then
  DIVERGENT=$(comm -23 \
    <(echo "$STAGED" | sort) \
    <(sort -u "$TOUCHED"))
else
  DIVERGENT="$STAGED"
fi

if [ -n "$DIVERGENT" ]; then
  if [ -f "$PENDING" ] && grep -q '^porque: .\+' "$PENDING"; then
    exit 0   # porquê presente; capturar-humano expande na próxima sessão
  fi
  echo "✋ Fora do fluxo do agente:"
  echo "$DIVERGENT"
  echo ""
  echo "Preencha .context/pending-human.md:"
  echo "  porque:   <por que você alterou>"
  echo "  conceito: <a ideia por trás>"
  exit 1
fi

exit 0
```

### .context/pending-human.md

```markdown
porque: 
conceito: 
```

### .context/NOW.md

```markdown
# NOW
objetivo: bootstrap do meta-repo do agente
etapa: implementar
passo: artefatos criados / instalação pendente
status: em-progresso

## Entendimento atual
Repo auto-hospeda o modelo: 9 skills nucleares, AGENTS.md como lei,
ADRs 0001–0010 derivadas de 6 rodadas de clarificação. Gate humano no
pre-commit, protocolo context-now atravessando tudo.

## Decisões desta execução
- Skill names em português (usuário fala pt-BR)
- ADRs completas: só a 0001 como exemplo, resto via catálogo (contenção aplicada à própria entrega)
- pre-commit v1 não cobre merges — aceito, documentado

## Próximo passo imediato
Instalar nos 3 CLIs (Codex, OpenCode, ZCode) e executar a primeira task real

## Bloqueios
—
```

### .context/log/001-clarificar.md

```markdown
# 001 — clarificar + modelar (a conversa que originou o sistema)
quando: [data]
input: ideia de agente simplificado baseado em ponytail + 5 repos de skills
output: modelo completo acordado (ADRs 0001–0010)
como: 6 rodadas; cada rodada atacou a pior fragilidade da anterior:
      unidade coesa → taxonomia+roteador → catálogo ADR → QA-first →
      context-now assimétrico → gate humano determinístico
artefatos: AGENTS.md, 9 skills, catálogos, hook, ADRs
implements usadas: — (não existiam ainda; bootstrap)
próxima: implementar → instalação nos CLIs
```
