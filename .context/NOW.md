# NOW
objetivo: topologia multiagente publicada no origin
etapa: concluída (LOG 009)
passo: 5 branches com upstream no origin (SSH)
status: concluído

## Entendimento atual
BACKLOGS/002 parcial (topologia): main, dev-ai, dev-ai-{codex,opencode,
zcode} publicadas em origin com tracking. dev-ai = integração ainda em
4a04042; dev-ai-zcode carrega o livro-razão do ZCode (LOG 008–009),
aguardando verificação cruzada para subir. Codex/OpenCode: checkout da
sua branch a partir do origin.

## Decisões que mudam o futuro
- Cada agente commita SÓ na sua dev-ai-<agente> (ou feature/* dela)
- Merge à dev-ai exige verificador ≠ implementador (BACKLOGS/002)
- Pendências do 002: gate de branch no hook, claim de micro, AGENTS emendado
- Achados 1–2 da auditoria 001 aguardam decisão do usuário
- IDEIA.md = spec autoritativa; DELTA_VERSION.md = histórico (achado 3)

## Próximo passo imediato
Merge de dev-ai-zcode à dev-ai quando houver verificador cruzado
(Codex/OpenCode/humano); primeira task real; decidir achados 1–2.

## Bloqueios
—
