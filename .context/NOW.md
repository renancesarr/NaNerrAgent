# NOW
objetivo: instalador v2 — merge de AGENTS.md + anonimato de alvos
etapa: concluída (LOG 012)
passo: 18/18 PASS; LOG 011 sanitizado; política em ADR-0011 emenda 1
status: concluído

## Entendimento atual
Instalador lida nativamente com AGENTS.md existente (preserva verbatim no
final, guard anti-duplicação). Política permanente: meta-repo NÃO conhece
projetos-alvo — registros dizem só "instalação funcionou". Sistema roda
em ≥1 projeto real.

## Decisões que mudam o futuro
- AGENTS.md existente no alvo = preservado verbatim no final (ADR-0011e1)
- Meta-repo não registra identidade de alvos (path/stack/dados); LOG 011
  reescrito como exceção autorizada ao append-only (documentada no 012)
- contencao: re-install não renova AGENTS.md já mergeado
- Pendências: achados 1–2 da auditoria; BACKLOGS/001 (goal/); resto do
  002 (hook de branch, claim, AGENTS); verificação cruzada do instalador
  p/ dev-ai (LOG 010+012 são o insumo do verificador)

## Próximo passo imediato
Decidir achados 1–2 da auditoria — ou implementar BACKLOGS/001.

## Bloqueios
—
