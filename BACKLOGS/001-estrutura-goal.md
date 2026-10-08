---
id: 001
status: backlog
tipo: implementacao-futura
unidades-alvo: [skills/agents-skills/decompor, CATALOG.md, .context/NOW.md]
criado: 2026-10-08
fonte: pedido do usuário (LOG 003)
---
# Pasta `goal/` — objetivos persistentes em árvore macro/micro

## Objetivo
Dar endereço permanente aos objetivos: a decomposição (hoje só narrada no
LOG) vira uma árvore de pastas navegável — goal → macro → micro — com estado
mutável (status) sem quebrar o LOG append-only.

## Motivo
- `decompor` produz checkpoint/macro/micro, mas as specs moram só no LOG;
  não existe onde atualizar o status de um micro sem reescrever o passado.
- O agente precisa achar "o micro ativo" em 1 leitura — mesma régua do CATALOG.

## Proposta original (do usuário)
```
goal/
└── 001-<slug-1-2-palavras>/
    ├── GOAL.md
    └── macro-goal/
        └── 001/
            ├── MACRO-GOAL.md
            └── 001-microgoal-<slug>.md
```

## Estrutura melhorada (v2 — proposta)
```
goal/
└── 001-<slug-1-2-palavras>/
    ├── GOAL.md            # objetivo, critérios, teste do objetivo, status
    └── macro/
        └── 001-<slug>/
            ├── MACRO-GOAL.md      # spec do macro: objetivo + critérios de aceite
            ├── 001-<slug-do-micro>.md
            └── 002-<slug-do-micro>.md
```

## Melhorias sobre a proposta original
| # | Mudança | Por quê |
|---|---|---|
| 1 | `NNN-slug` no macro (não só `001`) | ordena E nomeia; número puro não escala |
| 2 | micro = arquivo `.md`, não pasta | micro é atômico (horas); pasta para 1 arquivo é cerimônia |
| 3 | `macro/` (não `macro-goal/`) | o nível já está sob goal/; nome repetido é ruído |
| 4 | `GOAL.md`/`MACRO-GOAL.md` com frontmatter `status` + `decisions` | vínculo bidirecional com ADRs, igual a toda unidade (catalogar) |
| 5 | slug em kebab-case; numeração reinicia por pasta | escopo local, sem contador global para manter |

## Integração com o sistema existente
- **decompor** (emendar a skill): specs dos micros passam a morar em `goal/`;
  o LOG registra o ponteiro, não o conteúdo.
- **NOW**: "próximo passo imediato" referencia o micro ativo por caminho.
- **CATALOG**: `goal/` indexado (1 linha por goal; índice próprio se crescer).
- **gate**: `goal/*.md` são unidades — commit toca doc/status no mesmo commit.

## Aberturas (decidir na implementação)
1. `goal` ≡ `checkpoint` (renomear o termo em decompor) ou nível novo acima?
2. `GOAL.md` escrito por `decompor` direto, ou nasce uma skill `goal`?
3. Goals concluídos: `goal/done/`, `status: concluido` no frontmatter, ou remoção?
4. Precisa de ADR? (decisão: specs saem do LOG e ganham casa com estado mutável)

## Critérios de aceite (QA da implementação)
- [ ] `decompor` emendada apontando `goal/` como casa das specs
- [ ] achar "o micro ativo" = 1 leitura (NOW → caminho → arquivo)
- [ ] status de micro atualizável sem editar LOG (append-only preservado)
- [ ] gate cobre `goal/` (touched/porque) e CATALOG indexa o goal novo
