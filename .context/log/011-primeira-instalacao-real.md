# 011 — primeira instalação real (trivial — fast path, marco)
quando: 2026-10-08
classificação (conter, ANTES): trivial — execução do instalador num
       projeto real; diff no meta-repo = só este registro
o quê: a primeira instalação real funcionou — esqueleto plantado, gate
       ativo, 1º commit do alvo fluindo pelo gate, segredos cobertos pelo
       .gitignore do próprio alvo, AGENTS.md pré-existente preservado no
       final do novo. Detalhes do alvo não são registrados aqui (política:
       meta-repo não conhece projetos-alvo — ADR-0011 emenda 1, LOG 012).
porque: encerra o "zero horas de uso real" (IDEIA) — o sistema roda fora
evidência: 1º commit do alvo via gate; instalador 15/15 no teste da época
próxima: alvo ganha vida própria; meta segue com pendências (achados 1–2,
backlogs)
