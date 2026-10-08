# 004 — capturar-humano (origem: edição manual)
quando: 2026-10-08, commit 1274903
porque: linter de markdown (verbatim do usuário)
conceito: normalização de espaçamento — linha em branco após títulos
       (inferido do diff; usuário forneceu só o porque)
como: linter inseriu 1 linha em branco após cada um dos 3 headings ##
       (contexto, alternativas, consequências) da ADR-0001. Sem mudança
       semântica — estilo padrão de markdown (título separado do bloco).
       Primeiro uso REAL da via do porquê do gate: arquivo fora do
       .context/touched, liberado só porque o pending estava preenchido.
unidades afetadas: docs/adr/0001-unidade-coesa.md
impacto no NOW: nenhum — whitespace apenas; decisão da ADR inalterada;
       vínculos frontmatter/unidades intactos
estado: pending-human.md e touched limpos (consumidos por esta entrada)
