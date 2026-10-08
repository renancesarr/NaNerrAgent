# CATALOG — unidades

Índice de 1 linha por unidade: o agente descobre o que existe aqui, não no código.
Skills são autodocumentadas — o SKILL.md de cada uma é a sua doc de contexto.

| Unidade | Responsabilidade |
|---|---|
| AGENTS.md | leis, taxonomia de skills, pipeline, protocolo context-now |
| IDEIA.md | o problema (5 dores), os 9 mecanismos e as métricas de sucesso |
| DELTA_VERSION.md | registro histórico da conversa que originou o sistema |
| skills/agents-skills/clarificar | detecta ambiguidades do prompt, 3 opções, valida entendimento |
| skills/agents-skills/decompor | quebra objetivo em checkpoint→macro→micro com spec verificável |
| skills/agents-skills/modelar-dominio | glossário + ADRs com granularidade correta e vínculo |
| skills/agents-skills/catalogar | índice de unidades + doc de contexto + vínculo bidirecional |
| skills/agents-skills/implementar | roteia implements-skills e executa o micro |
| skills/agents-skills/verificar-objetivo | gate QA-first com evidência executável |
| skills/agents-skills/conter | classifica task trivial/média/grande ANTES + fast path + contenção |
| skills/agents-skills/capturar-humano | converte edição humana em conhecimento no LOG |
| skills/agents-skills/auditar | diagnóstico de degradação com evidência do LOG |
| hooks/pre-commit | gate determinístico: divergência staged×touched exige porquê (ADR-0007) |
| ADR-CATALOG.md | índice das decisões ADR-0001 a ADR-0010 |
| IMPLEMENTS-CATALOG.md | vazio no bootstrap — meta-repo sem dialeto próprio |
