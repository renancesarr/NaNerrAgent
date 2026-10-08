# 002 — bootstrap + otimização (implementar → verificar-objetivo)
quando: 2026-10-08
input: DELTA_VERSION.md (blueprint), IDEIA.md (visão), repo com AGENTS.md e
       9 skills prontas; catálogos, ADR-exemplo, hook, NOW e LOG vazios/ausentes;
       repo sem git
classificação (conter, ANTES da execução): grande — várias unidades, muda o
       estado global do repo (git, gate, catálogos, instalação CLI)
escopo decidido com o usuário: só o bootstrap (DELTA_VERSION.md intacto,
       sem trim das skills) + instalação apenas no ZCode
implements selecionadas: nenhuma aplicável — meta-repo é docs/bootstrap,
       sem dialeto de implementação (lacuna catalogada em IMPLEMENTS-CATALOG)
objetivo: bootstrap funcional — artefatos completos, gate executável,
       primeiro commit através do gate, 9 skills visíveis no ZCode
teste do objetivo: cenários 1–3 do gate com comando+saída abaixo; índice
       responde "quem classifica tasks?" em uma leitura
evidência: (preenchida ao fechar — ver seção Evidência)
unidades: hooks/pre-commit, CATALOG.md, ADR-CATALOG.md, IMPLEMENTS-CATALOG.md,
       docs/adr/0001-unidade-coesa.md, .context/{NOW.md,touched,pending-human.md}
