---
id: 0012
status: accepted
supersedes: —
units: [goal/, skills/agents-skills/decompose, skills/agents-skills/implement, skills/agents-skills/verify-objective, CATALOG.md]
---
# Objectives live in goal/ — persistent, mutable status; PLAN.md is retired

## context
Decompose produced specs in a single mutable file (.context/PLAN.md) while
the LOG stayed append-only. A spec's status had no durable home: the PLAN
was task-scoped and rewritten per objective, the LOG can't be edited, and
the NOW only points. BACKLOGS/001 asked for a persistent goal tree
(goal → macro → micro) with addressable files and mutable status.
Backlog openings resolved: goal ≡ checkpoint (rename, no extra level);
no new skill (decompose absorbs it); done = `status: done` in frontmatter,
file stays in place; this ADR records the retirement of PLAN.md.

## alternatives
- Keep PLAN.md and add goal/ beside it: rejected — two homes for the same
  spec violates DRY; drift between them is guaranteed.
- goal/ as pure index pointing back into the LOG: rejected — the LOG is
  append-only; a mutable status would require editing history.
- goal/ with a new skill owning it: rejected — ceremony; decompose already
  owns decomposition artifacts.

## consequences
We gain: the active micro is found in one read (NOW → path → file);
status changes without touching the LOG; micro files carry frontmatter
(`status`, `owner` for the BACKLOGS/002 claim) and bidirectional ADR
links; the macro level is optional (single-component goals put micros
next to GOAL.md — YAGNI applied to the tree itself).
We give up: PLAN.md (its map moves into GOAL.md; its specs move into
micro files); one more directory to keep indexed via CATALOG.
Rule: goal/ files are units — commits touch doc/status in the same commit
(ADR-0004); `done` in a micro is written only by verify-objective.
