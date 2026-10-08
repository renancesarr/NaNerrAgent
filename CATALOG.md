# CATALOG — unidades

Índice de 1 linha por unidade: o agente descobre o que existe aqui, não no código.
Skills são autodocumentadas — o SKILL.md de cada uma é a sua doc de contexto.

| Unidade | Responsabilidade |
|---|---|
| AGENTS.md | leis, taxonomia de skills, pipeline, protocolo context-now |
| IDEIA.md | spec autoritativa do projeto: problema, 9 mecanismos, métricas (auditoria 001, achado 3) |
| DELTA_VERSION.md | referência histórica — não é unidade ativa (auditoria 001, achado 3) |
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
| BACKLOGS/001-estrutura-goal.md | backlog: pasta goal/ com árvore macro/micro — implementação futura |
| BACKLOGS/002-fluxo-multiagente.md | backlog: branches dev-ai-* por agente + verificação cruzada — implementação futura |
| installer/install.sh | instala o sistema num projeto-alvo: leis + gate + catálogos zerados + .context fresco (ADR-0011) |
| installer/templates/ | esqueletos zerados (catálogos, NOW, pending, touched, log-001) aplicados pelo install.sh |
| installer/test-install.sh | teste do objetivo do instalador: alvo temporário real, 18 asserts, commit via gate |
