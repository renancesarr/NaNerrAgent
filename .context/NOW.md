# NOW
objetivo: bootstrap funcional do meta-repo do agente
etapa: implementar (LOG 002)
passo: artefatos criados / git + gate + instalação ZCode pendentes
status: em-progresso

## Entendimento atual
Repo auto-hospeda o modelo: 9 skills nucleares (evoluídas além do blueprint),
AGENTS.md como lei, ADRs 0001–0010 em catálogo. Catálogos, ADR-exemplo,
hook e .context recém-criados; zero uso real ainda.

## Decisões desta execução
- Escopo fechado com o usuário: só bootstrap — DELTA_VERSION.md intacto, sem trim das skills
- Instalação: só ZCode nesta sessão (symlink por skill, fonte única no repo)
- Gate via core.hooksPath=hooks (hook versionado no repo)
- ADRs completas em arquivo: só 0001; resto vive no ADR-CATALOG até promoção

## Próximo passo imediato
git init → primeiro commit via gate → testes dos 3 cenários → symlinks ZCode

## Bloqueios
—
