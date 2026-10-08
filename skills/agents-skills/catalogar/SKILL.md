---
name: catalogar
description: >
  Mantém o índice do que existe: uma linha por unidade em CATALOG.md, um .md
  de contexto por unidade, vínculo bidirecional com ADRs — sincronizados no
  mesmo commit que o código. Invocada por implementar antes de todo commit
  que toca unidade; por modelar-dominio ao re-vincular; por capturar-humano
  e auditar em manutenção. Nunca roda solta.
---

# catalogar

## Objetivo
O agente descobre o que existe lendo um índice, não o código inteiro.
Esta skill mantém o índice verdadeiro — e é a metade **unidade** do vínculo
com ADRs (a metade **decisão** é `modelar-dominio`):
modelar-dominio cuida de como o sistema fala e decide; catalogar, do que ele é.

## A invariante central (sem exceção)
> **Unidade staged → seu .md staged. No mesmo commit.**

O fast path reduz o CUSTO da sincronia, nunca a obrigação dela.
Exceção é onde gate apodrece: a primeira brecha vira a segunda em duas semanas.

## O que é unidade
| É | Não é |
|---|---|
| arquivo de código com comportamento próprio (ADR-0001) | lockfile, artefato gerado, build |
| pasta-conceito (pacote Go, mod Rust, pkg Python) → `UNIT.md` dentro | config sem lógica (declara no LOG, sem doc) |

Teste: **uma task futura precisaria ler isto para decidir algo?**
Sim → unidade. Não → não cataloga. É o mesmo teste de `clarificar`:
o que não muda decisão futura é ruído.

## Artefatos e template
`CATALOG.md`: `| caminho | responsabilidade em 1 linha |`, seções por diretório.
O catálogo aponta; nunca duplica o conteúdo da doc (DRY).

Doc da unidade (`<nome>.md` ao lado do arquivo; `UNIT.md` para pasta-unidade):

```markdown
---
unidade: caminho/relativo/ao/repo
decisions: [ADR-NNN, ...]
última-sincronia: AAAA-MM-DD
---
# [nome]
responsabilidade: [1–2 frases]
interface: [o público, assinatura mínima — se expõe algo]
dependências: [unidades e ADRs]
exemplo: [uso mínimo real — quando ajudar]
notas: [o que o próximo leitor precisa e não vê na assinatura]
```

Teto: **~40 linhas**. Doc que estoura sistematicamente = unidade grande demais
— mesma lógica do teto do NOW: o sintoma aponta para a causa raiz,
que fica uma etapa atrás, não na escrita.

## Processo — por ponto de entrada
| Gatilho | Origem | Ação |
|---|---|---|
| commit próximo | `implementar` | sincroniza toda unidade tocada (abaixo) |
| re-vinculação | `modelar-dominio` | atualiza `decisions` no frontmatter |
| edição humana | `capturar-humano` | doc invalidada → reescrever seções afetadas |
| drift detectado | `auditar` | correção flui por aqui — auditar só reporta |
| repo existente | bootstrap | catalog-on-touch (abaixo) |

## Sincronia — três níveis (o caso comum)
Ao fechar um diff em uma unidade:
1. **contrato mudou** (interface, parâmetros, comportamento prometido):
   atualiza interface/dependências/notas + `última-sincronia`.
2. **interna mudou, contrato igual**: notas se algo relevante + sincronia.
3. **nada relevante** (typo, formatação): `última-sincronia` + declaração
   `contrato inalterado`. É 1 linha — o trivial paga pouco, nunca zero.

A declaração mora na entrada de LOG da transição:
`sincronia: caminho → contrato inalterado | interface atualizada ([o quê]) | doc criada`.

O `auditar` confere `última-sincronia` contra `git log -1 -- <unidade>`:
data da doc < data do último commit na unidade = drift.

## Criação · deleção · renomeação
- **Cria**: doc + linha no CATALOG + `decisions` com as ADRs existentes que
  a sustentam (o lado de lá é `modelar-dominio`).
- **Deleta**: remove doc, remove linha, **varre ADR-CATALOG por ponteiros
  para a unidade** — achou → dispara `modelar-dominio` (re-vincular ou órfã).
- **Renomeia/move**: move a doc junto, atualiza caminho no CATALOG e nas ADRs
  vinculadas, ajusta apontamentos em NOW/PLAN. Renome caro é o preço de um
  índice confiável — registre no LOG e siga.

## Brownfield — catalog-on-touch
Repo existente sem catálogo NÃO se cataloga inteiro de uma vez.
Catalogue o que tocar; o índice cresce onde o uso prova que a entrada é
necessária. Catalogação total é task explícita (classificada por `conter`
como grande) — e na maioria dos repos é YAGNI.

## Handshake com o gate
Docs e CATALOG entram em `.context/touched` junto com as unidades.
O pre-commit verifica a invariante; esta skill garante o estado que passa.

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "Arquivo pequeno, se explica" | O catálogo é para o agente que NUNCA abriu este arquivo. |
| "Atualizo a doc no final" | Final de quê? Cada commit é um estado válido ou não é. |
| "Mudança só interna" | Então declare contrato inalterado — 1 linha. Sem declaração, auditor não distingue preguiça de esquecimento. |
| "Doc completa é melhor" | Doc de 200 linhas ninguém lê — e a que ninguém lê apodrece primeiro. |
| "Catalogo o repo inteiro" | Catalog-on-touch. Doc escrita sem necessidade imediata apodrece antes do primeiro uso. |
| "Deleção não precisa de cerimônia" | Linha morta no índice = agente confia em fantasma. Pior que não ter índice. |

## Verificação
- [ ] Toda unidade staged tem .md staged (trivial: com bump de sincronia).
- [ ] Unidade criada: linha no CATALOG + frontmatter com `decisions` corretas.
- [ ] `decisions` do frontmatter ↔ `unidades` das ADRs — batendo nos dois lados.
- [ ] `última-sincronia` = hoje para toda doc tocada.
- [ ] Deleção/renomeação: CATALOG e ponteiros de ADR ajustados.
- [ ] Docs ≤ ~40 linhas; CATALOG aponta, nunca duplica.