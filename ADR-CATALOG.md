# ADR-CATALOG

| ID | Status | Decisão (1 linha) | Unidades |
|----|--------|-------------------|----------|
| 0001 | aceita | Responsabilidade única por unidade coesa, não por função/arquivo | todas as skills, AGENTS.md |
| 0002 | aceita | Taxonomia 3 camadas; implementar é a única porta para implements | implementar, AGENTS.md |
| 0003 | aceita | Catálogo + doc por unidade como índice de contexto do agente | catalogar, CATALOG.md |
| 0004 | aceita | ADRs com vínculo bidirecional e atualização obrigatória no mesmo commit | modelar-dominio, catalogar |
| 0005 | aceita | QA-first: teste do objetivo é o gate; TDD unitário é higiene | verificar-objetivo |
| 0006 | aceita | context-now: NOW+LOG; escreve sempre, lê sob 3 gatilhos | protocolo, todas |
| 0007 | aceita | Gate humano determinístico no pre-commit + enriquecimento adiada | capturar-humano, hooks/pre-commit |
| 0008 | aceita | Fast path obrigatório ao trivial | conter |
| 0009 | aceita | Teto do NOW como diagnóstico de decomposição | protocolo, decompor |
| 0010 | aceita | DDD-lite: linguagem ubíqua sim, cerimônia formal não | modelar-dominio |

ADR completa em arquivo: apenas 0001 (exemplo canônico); as demais vivem
neste índice até cruzarem o teste de promoção (modelar-dominio, granularidade).
