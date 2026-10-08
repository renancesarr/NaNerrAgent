---
id: 0001
status: aceita
supersedes: —
unidades: [skills/agents-skills/*/SKILL.md, AGENTS.md]
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
