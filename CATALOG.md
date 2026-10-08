# CATALOG — units

One line per unit: the agent discovers what exists here, not in the code.
Skills are self-documenting — each one's SKILL.md is its context doc.

| Unit | Responsibility |
|---|---|
| AGENTS.md | laws, skills taxonomy, pipeline, context-now protocol |
| IDEA.md | authoritative spec: the problem (5 pains), 9 mechanisms, success metrics |
| DELTA_VERSION.md | historical record of the conversation that originated the system |
| installer/install.sh | installs the system into a target project: laws + gate + zeroed catalogs + fresh .context (ADR-0011) |
| installer/templates/ | zeroed skeletons (catalogs, NOW, pending, touched, log-001) applied by install.sh |
| installer/test-install.sh | installer's objective test: real temporary target, 20 asserts, commit via gate |
| skills/agents-skills/clarify | detects prompt ambiguities, 3 options, validates understanding |
| skills/agents-skills/decompose | splits objective into checkpoint→macro→micro with verifiable spec |
| skills/agents-skills/model-domain | glossary + ADRs with correct granularity and linking |
| skills/agents-skills/catalog | unit index + context doc + bidirectional linking |
| skills/agents-skills/implement | routes implements-skills and executes the micro |
| skills/agents-skills/verify-objective | QA-first gate with executable evidence |
| skills/agents-skills/contain | classifies task trivial/medium/large BEFORE + fast path + containment |
| skills/agents-skills/capture-human | converts human edits into LOG knowledge |
| skills/agents-skills/audit | degradation diagnosis with LOG evidence |
| hooks/pre-commit | deterministic gate: staged×touched divergence requires a why (ADR-0007) |
| ADR-CATALOG.md | index of decisions ADR-0001 to ADR-0011 |
| IMPLEMENTS-CATALOG.md | empty in bootstrap — meta-repo has no dialect of its own |
| BACKLOGS/001-goal-structure.md | backlog: goal/ folder with macro/micro tree — IMPLEMENTED (goal/001, ADR-0012) |
| BACKLOGS/002-multiagent-flow.md | backlog: dev-ai-* branches per agent + cross-verification |
| goal/ | persistent objectives tree: goals → (macros) → micros with mutable status (ADR-0012) |
