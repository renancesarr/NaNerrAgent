---
id: 0013
status: accepted
supersedes: —
units: [skills/agents-skills/decompose, goal/, CATALOG.md]
---
# goal/ is the single authoritative home of objectives; vision docs are optional context

## context
Projects may carry a vision doc (IDEA.md) and the goal/ tree. Requiring
both invites duplication: an objective list maintained in two places
drifts, and the drift is exactly the stale-doc problem this system exists
to kill (AGENTS.md law 2 — DRY). User decision: having both is NOT
mandatory; when objectives exist, focus on goals.

## alternatives
- Both mandatory (vision doc + goals): rejected — duplicated objective
  lists violate DRY; every status change would need two edits.
- Vision doc as the only objective home: rejected — no mutable status,
  no addressable micros (that was PLAN.md's failure, ADR-0012).
- Goals mandatory in every repo: rejected — a repo with no persistent
  objectives carries an empty tree (YAGNI).

## consequences
We gain: one rule for any agent — objectives are minted ONLY into goal/;
a vision doc that states objectives has them extracted into goal/ and
keeps only vision (problem, mechanisms, metrics, non-goals). Either
artifact may exist alone; no ceremony to create the other.
We give up: a single familiar entry point for "what does this project
want" — the answer is now "read goal/ if it exists, else the vision doc".
