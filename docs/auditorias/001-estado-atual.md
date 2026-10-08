# Auditoria 001 — estado atual — 2026-10-08

gatilho: pedido do usuário para conferir o que foi implementado
escopo: estado versionado, protocolo, catálogo, ADRs e gate local

## Achados

| # | grav. | achado | evidência | causa provável | correção mínima | skill dona |
|---|---|---|---|---|---|---|
| 1 | maior | O gate aceita qualquer arquivo divergente com `porque:` preenchido; não exige `conceito:` nem distingue o fast path de Markdown da regra geral. | `hooks/pre-commit:20-24`; `AGENTS.md:98-101` pede `porque` + `conceito`, com exceção limitada a lockfiles e Markdown sem frontmatter. | A condição do hook implementa só a primeira metade do contrato. | Exigir os dois campos no caminho geral e codificar explicitamente a exceção documentada. | `capturar-humano` |
| 2 | maior | `auditar` define `doc>40` como estouro, enquanto AGENTS orienta unidades com 50–150 linhas. As nove skills têm entre 90 e 129 linhas e seriam sinalizadas pelo próprio auditor. | `skills/agents-skills/auditar/SKILL.md:42`; `AGENTS.md:20-22`; `wc -l skills/agents-skills/*/SKILL.md`. | Limite de documentos de contexto e limite de unidade foram misturados ou não sincronizados. | Definir uma régua compatível para SKILL.md e docs de contexto, e ajustar a varredura. | `auditar` |
| 3 | menor | O CATALOG ainda inclui `DELTA_VERSION.md` como unidade. Pela orientação do usuário nesta auditoria, ele é exemplo histórico; `IDEIA.md` é a fonte autoritativa do projeto. | `CATALOG.md:8-10`; `IDEIA.md`; clarification recebida nesta conversa. | O histórico foi mantido no índice sem marcar sua autoridade. | Reclassificar a entrada como referência histórica ou removê-la do índice de unidades na próxima edição do catálogo. | `catalogar` |

## Verificações sem achado

- Estado de trabalho limpo: `git status --porcelain=v1` não retornou arquivos.
- Hook ativo no repositório: `core.hooksPath=hooks`; `hooks/pre-commit` tem permissão executável.
- Na inspeção inicial, o NOW tinha 25 linhas; os cinco LOGs existentes tinham no máximo 56 linhas; a ADR completa tinha 24 linhas. O NOW de fechamento desta auditoria ficou com 20 linhas.
- As nove skills existem e aparecem no CATALOG. O único registro de instalação do ZCode é o LOG 002; os symlinks não foram inspecionados fora deste repositório nesta auditoria.
- O LOG 002 registra cenários de bloqueio, liberação por `porque` e passagem pelo fluxo declarado, além de duas falhas reais corrigidas. Não reexecutei esses cenários nesta revisão.

## Estado geral

O bootstrap está materializado: nove skills, catálogos, uma ADR completa, backlog, estado persistente e hook configurado. O primeiro dogfood também deixou evidência útil de falhas encontradas e corrigidas. Ainda não há evidência de uso em um repositório-alvo real, como prevê o próximo passo do NOW. Os achados 1 e 2 são inconsistências internas verificáveis e merecem correção antes de confiar no gate e na auditoria como enforcement.
