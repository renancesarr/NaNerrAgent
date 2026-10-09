# ADR-CATALOG

| ID | Status | Decision (1 line) | Units |
|----|--------|-------------------|-------|
| 0001 | accepted | Single responsibility per cohesive unit, not per function/file | all skills, AGENTS.md |
| 0002 | accepted | 3-layer taxonomy; implement is the only gateway to implements | implement, AGENTS.md |
| 0003 | accepted | Catalog + doc per unit as the agent's context index | catalog, CATALOG.md |
| 0004 | accepted | ADRs with bidirectional linking and mandatory same-commit update | model-domain, catalog |
| 0005 | accepted | QA-first: objective test is the gate; TDD unit tests are hygiene | verify-objective |
| 0006 | accepted | context-now: NOW+LOG; always written, read on 3 triggers | protocol, all |
| 0007 | accepted | Deterministic human gate on pre-commit + deferred enrichment | capture-human, hooks/pre-commit |
| 0008 | accepted | Mandatory fast path for trivia | contain |
| 0009 | accepted | NOW ceiling as decomposition diagnosis | protocol, decompose |
| 0010 | accepted | DDD-lite: ubiquitous language yes, formal ceremony no | model-domain |
| 0011 | accepted | Installer: skeleton per project, global skills; target AGENTS.md preserved at end; anonymous targets | installer/ |
| 0012 | accepted | Each agent has one branch and isolated Git identity; commit and merge hooks enforce the mapping | AGENTS.md, hooks/check-agent-branch.sh, hooks/pre-commit, hooks/pre-merge-commit, .context/agent-branches |

Full ADR files: 0001 (canonical example), 0011 (installer), and 0012
(agent branch identity); remaining decisions stay in this index until they
pass the promotion test (model-domain, granularity).
