# NOW
objetivo: topologia de branches multiagente ativa
etapa: concluída (LOG 008)
passo: dev-ai + dev-ai-{codex,opencode,zcode} criadas; ZCode em dev-ai-zcode
status: concluído

## Entendimento atual
BACKLOGS/002 implementado PARCIALMENTE: só a topologia. main = estável
(4a04042, 2 commits à frente do origin), dev-ai = integração (igual à
main), dev-ai-zcode recebe o trabalho do ZCode (LOG 008 incluso).
Branches do Codex e do OpenCode prontas e intocadas.

## Decisões que mudam o futuro
- Cada agente commita SÓ na sua dev-ai-<agente> (ou feature/* dela)
- Merge à dev-ai exige verificador ≠ implementador (BACKLOGS/002)
- Pendências do 002: gate de branch no hook, claim de micro, AGENTS emendado
- Achados 1–2 da auditoria 001 aguardam decisão do usuário
- IDEIA.md = spec autoritativa; DELTA_VERSION.md = histórico (achado 3)

## Próximo passo imediato
Trabalhar em dev-ai-zcode; merge à dev-ai só com verificador cruzado
(Codex/OpenCode/humano). Primeira task real ou resto do BACKLOGS/002.

## Bloqueios
—
