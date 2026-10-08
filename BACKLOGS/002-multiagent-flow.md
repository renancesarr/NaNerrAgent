---
id: 002
status: implemented
type: future-implementation
target-units: [hooks/pre-commit, .context/, BACKLOGS/001-goal-structure.md, skills/agents-skills/verify-objective, skills/agents-skills/decompose]
created: 2026-10-08
source: user request (LOG 006)
---
# Multiagent flow — 3 agents, own branch, cross-verification

## Objective
The project evolves with 3 coding agents (Codex, ZCode, OpenCode) in
parallel, without overwriting each other's work, with one non-negotiable rule:
**no agent validates its own work — whoever verified is always another**.

## Original proposal (from the user)
- `dev-ai` — main integration branch
- `dev-ai-codex`, `dev-ai-zcode`, `dev-ai-opencode` — branch per agent
- `feature/feature-name` is born from the agent's branch, returns to it,
  then the agent's branch merges into `dev-ai`
- care to avoid overlapping work; structured tasks
- an agent never creates a test for itself

## Proposed topology (v2)
```
main      (stable — promotion decided by the HUMAN)
└─ dev-ai (integration — receives ONLY merges verified by ANOTHER agent)
   ├─ dev-ai-codex     ── feature/<slug>
   ├─ dev-ai-zcode     ── feature/<slug>
   └─ dev-ai-opencode  ── feature/<slug>
```

## Feature flow (v2)
1. Agent picks an ownerless micro in goal/ (BACKLOGS/001) and writes `owner:`
   in the frontmatter — claim commit on dev-ai-<agent> BEFORE coding.
2. `feature/<slug>` is born from dev-ai-<agent>.
3. Implement; unit tests (TDD, internal hygiene) belong to the implementer.
4. Feature returns to dev-ai-<agent> (merge by its own author).
5. dev-ai-<agent> → dev-ai ONLY after ANOTHER agent runs the objective test
   of the spec and reviews the diff. Conflict: resolved by the incoming
   author.
6. dev-ai → main: human's decision (the human is the release gate).

## Improvements over the original proposal
| # | Change | Why |
|---|---|---|
| 1 | micro claim before coding (`owner:` in goal/) | a branch isolates, it doesn't coordinate; the claim is what prevents overlap |
| 2 | verifier ≠ implementer at the dev-ai entry gate | "never tests itself" with a single checkpoint |
| 3 | unit tests from the implementer; what crosses agents is the objective test | QA-first hierarchy (AGENTS.md §5) preserved |
| 4 | branch gate in pre-commit (extension of ADR-0007) | direct agent commit to dev-ai/main = deterministic block |
| 5 | .context per branch; dev-ai carries the integrated state | the feature's NOW/LOG travels in the feature; the merge reconciles |
| 6 | main = stable, promoted by the human | closes the arc: human gate at commit, human gate at release |

## Anti-overlap (what actually protects the work)
- Two agents may code the SAME task on different branches — what coordinates
  that is the claim (`owner:` in the goal/ micro), not the branch.
- Never `--force`/overwrite; merge conflict resolved by the incoming author,
  with the verifier checking the other side's result.
- A micro with an owner only changes owner if the owner releases it
  (`status: abandoned`).

## Open questions (decide at implementation)
1. "Never tests itself": only the objective test, or unit tests too?
   (proposal: only the gate — unit tests are the author's internal hygiene)
2. Fallback with a single active agent: does the human verify, or wait for a
   2nd agent?
3. Race window on the claim (2 agents pick the same micro nearly together):
   resolved by commit order in goal/, or by a lock?
4. Branch gate: block dev-ai AND main in pre-commit, or only main?
5. `--no-ff` merge into dev-ai so the integration history stays visible?
6. Remote: everyone pushes to origin, or only dev-ai and main (avoids
   zombie branches)?
7. ADRs to create: "verifier ≠ implementer", "dev-ai topology"

## Acceptance criteria (QA of the implementation)
- [ ] 3 agents in parallel without unreviewed overlapping work: every path
      to dev-ai goes through verifier ≠ author, with evidence in the LOG
- [ ] direct agent commit to dev-ai/main blocked by the hook
- [ ] micro has ONE active owner; claim visible in goal/ before the code
- [ ] objective test executed by another agent (command+output in the LOG)
- [ ] dev-ai's .context reflects the integrated post-merge state
- [ ] AGENTS.md and touched skills (decompose, verify-objective) amended
