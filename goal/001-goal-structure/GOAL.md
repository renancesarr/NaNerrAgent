---
id: 001
status: in-progress
created: 2026-10-08
source: BACKLOGS/001-goal-structure.md (user request: implement it)
---
# goal-structure — persistent objectives tree (goal/)

## Objective
Implement BACKLOGS/001: goal/ as the persistent home of objectives with
mutable status, replacing .context/PLAN.md (ADR-0012). This very goal is
the first instance of the structure it creates (dogfood).

## Success metric
The active micro is found in ONE read (NOW → path → file); a micro's
status changes without editing any LOG file; the amended skills reference
goal/ with zero PLAN.md mentions left.

## Map
| # | micro | depends on | status | objective test (1 line) |
|---|-------|------------|--------|-------------------------|
| 1 | 001-adr-and-catalog.md | — | done | ADR-0012 file exists, listed in ADR-CATALOG, openings resolved in body |
| 2 | 002-amend-skills.md | 1 | done | grep PLAN.md across skills → 0 hits (history files excluded) |
| 3 | 003-dogfood-and-verify.md | 2 | done | NOW→path→micro in 1 read; status flipped without LOG edits; suite green |
