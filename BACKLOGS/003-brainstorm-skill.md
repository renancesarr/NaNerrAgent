---
id: 003
status: open
type: future-implementation
target-units: [skills/agents-skills/brainstorm, skills/agents-skills/clarify, skills/agents-skills/decompose]
created: 2026-10-08
source: user request (LOG 017)
---
# `brainstorm` skill — turn a raw idea into IDEA.md + goal/ tree

## Objective
Give the system a first-contact skill: a project with zero artifacts gets
an interactive session that produces the two founding artifacts — the
vision doc (IDEA.md, optional per ADR-0013) and the goal/ tree (the
authoritative objectives home, ADR-0012) — instead of an agent inventing
objectives silently.

## The flow the user described
1. **Wide picture** — agent interviews the user about the idea: what is
it, who uses it, what problem it kills, constraints (language, platform,
deploy), what it is NOT.
2. **Funnel** — series of narrowing questions per axis, 3–5 at a time,
each with numbered options where possible (answerable with digits):
   - scope: what is in v1, what is explicitly out
   - success: how do we know it worked (metrics for IDEA)
   - objectives: what are the checkpoint-sized goals
   - goals→micros: decomposition happens AFTER, via decompose (no
     overlap with that skill's job)
3. **Adjust** — user corrects/refines answers; agent updates the draft
   each round; loop until user approves.
4. **Output** — IDEA.md (vision: problem, mechanism, metrics, non-goals)
   and goal/NNN-slug/ trees (goals with map of micros left for decompose
   — or draft micros at agent's discretion).

## Relationship with existing skills (decide at implementation)
| Question | Proposal |
|---|---|
| New agent-skill or extends clarify? | New skill: clarify operates on a canonical prompt for a task; brainstorm operates on a project with NO artifacts. Different input, different output. Keeps clarify small (cohesive unit, law 1). |
| Where does it fit in the pipeline? | BEFORE contain: it's the entry door for project creation, not for task execution. AGENTS.md §1 gains "no artifacts → brainstorm (project creation) or contain (task in existing project)". |
| IDEA.md vs goal/ (ADR-0013)? | brainstorm produces both when the user wants both; goals are the authority — IDEA.md never gets an objective list (extracted into goal/). |
| Anti-rationalization? | Own table: "the idea is clear" (it never is at 1 sentence); "I'll skip the funnel" (scope creep comes from unasked questions); "brainstorm is for beginners" (6 rounds of clarification produced this very system). |
| Verification? | User explicitly approves the two artifacts (explicit answer, never silence); zero ambiguities listable; objectives live ONLY in goal/; IDEA has no objective list. |

## Aberturas (decidir na implementação)
1. Skill creates artifacts directly, or drafts for user-written files?
2. Medium/large projects: one GOAL.md with many goals, or one goal folder
   per checkpoint? (proposal: one folder per goal, decompose decides depth)
3. Should brainstorm UPDATE goal/ trees in later sessions (re-brainstorm)
   or hand off to audit when vision drifts?
4. Non-goal: brainstorm must NOT do decompose's job (micro specs) — the
   boundary is the micro spec with its objective test.

## Acceptance criteria (QA of the implementation)
- [ ] skill file at skills/agents-skills/brainstorm/SKILL.md (frontmatter,
      objective, process, anti-rationalization, verification)
- [ ] AGENTS.md §1 amended: "no artifacts → brainstorm" entry door
- CATALOG/ADR-CATALOG indexed; ADR if it changes a lasting trade-off
  (it does: new entry door — ADR recommended)
- [ ] tested once in a real new-project session (the LOG is the evidence)
