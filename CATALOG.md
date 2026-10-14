# CATALOG — units

One line per unit: the agent discovers what exists here, not in the code.
Skills are self-documenting — each one's SKILL.md is its context doc.

| Unit | Responsibility |
|---|---|
| AGENTS.md | laws, skills taxonomy, pipeline, context-now protocol |
| IDEA.md | authoritative spec: the problem (5 pains), 9 mechanisms, success metrics |
| DELTA_VERSION.md | historical record of the conversation that originated the system |
| installer/install.sh | installs laws, executable hooks, zeroed catalogs, and fresh .context without copying meta-only agent mappings (ADR-0011, ADR-0012) |
| installer/test-install.sh | objective tests for installation, existing gates, and exact agent branch/name/email enforcement |
| installer/templates/ | zeroed catalogs/context and touched manifest for installed hooks; no meta agent mapping (ADR-0011, ADR-0012) |
| skills/agents-skills/clarify | detects prompt ambiguities, 3 options, validates understanding |
| skills/agents-skills/decompose | splits objective into checkpoint→macro→micro with verifiable spec |
| skills/agents-skills/model-domain | glossary + ADRs with correct granularity and linking |
| skills/agents-skills/catalog | unit index + context doc + bidirectional linking |
| skills/agents-skills/implement | routes implements-skills and executes the micro |
| skills/agents-skills/verify-objective | QA-first gate with executable evidence |
| skills/agents-skills/contain | classifies task trivial/medium/large BEFORE + fast path + containment |
| skills/agents-skills/capture-human | converts human edits into LOG knowledge |
| skills/agents-skills/audit | degradation diagnosis with LOG evidence |
| hooks/pre-commit | validates agent branch identity (ADR-0012), gates protected branches before any early exit (ADR-0014), then staged×touched divergence requires a why (ADR-0007) |
| hooks/check-agent-branch.sh | shared check of agent ID, Git name, Git email, and current branch against the map (ADR-0012) |
| hooks/pre-merge-commit | checks agent identity and branch before automatic merge commits (ADR-0012) |
| .context/agent-branches | authoritative agent ID/name/email/branch mapping for this meta-repository (ADR-0012) |
| ADR-CATALOG.md | index of decisions ADR-0001 to ADR-0015 |
| IMPLEMENTS-CATALOG.md | empty in bootstrap — meta-repo has no dialect of its own |
| BACKLOGS/002-multiagent-flow.md | backlog: multiagent flow — IMPLEMENTED (ADR-0014, AGENTS.md §8, branch gate) |
| BACKLOGS/003-brainstorm-skill.md | backlog: brainstorm skill — raw idea → IDEA.md + goal/ via funnel questions |
| BACKLOGS/004-agent-identity-config.md | backlog: deterministic agent identity, Git config, GitHub PR actor, and independent verification |
| goal/ | persistent objectives tree: goals → (macros) → micros with mutable status (ADR-0015) |
