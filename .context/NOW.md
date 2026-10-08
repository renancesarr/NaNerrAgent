# NOW
objetivo: instalador de projeto (feature/instalador)
etapa: implementação concluída (LOG 010)
passo: 15/15 PASS; merge à dev-ai-zcode pendente neste passo
status: em-progresso

## Entendimento atual
Instalador pronto (ADR-0011): whitelist copia AGENTS.md + hook da fonte
viva e planta catálogos/.context zerados via templates; skills ficam
globais por CLI. Idempotente (--force preserva .context/log). O touched
do alvo nasce declarando os plantados — o 1º commit dele já flui pelo
gate. Teste do objetivo: 15/15 PASS em alvo temporário real.

## Decisões que mudam o futuro
- ADR-0011: esqueleto copiado por projeto; skills globais por máquina
- Uso: installer/install.sh <dir-do-projeto-alvo> [--force]
- Primeiro uso do fluxo feature/* do BACKLOGS/002 (branch por feature,
  merge do autor à dev-ai-<agente>, verificação cruzada p/ dev-ai)
- Pendências: achados 1–2 da auditoria; resto do BACKLOGS/002 (hook de
  branch, claim, AGENTS emendado); BACKLOGS/001 (goal/)

## Próximo passo imediato
Merge feature/instalador → dev-ai-zcode (merge do autor, --no-ff),
deletar a feature, push. Subir à dev-ai SÓ com verificador cruzado.

## Bloqueios
—
