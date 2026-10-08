# NOW
objective: implement BACKLOGS/001 (goal/ structure)
stage: done (LOG 015)
step: goal/ live, PLAN.md retired, skills amended — awaiting cross-verification
status: done

## Current understanding
goal/ is the persistent home of objectives (ADR-0012): goal/NNN-slug/
with GOAL.md (map + success metric) and micro files (spec + mutable
status frontmatter; `done` written only by verify-objective). Macro level
optional. First instance: goal/001-goal-structure (this very task —
dogfood). PLAN.md retired with zero living references.

## Immediate next step (active micro path)
goal/001-goal-structure/003-dogfood-and-verify.md — status: done;
goal map all-done. Next: cross-verification of feature/goal-structure,
then user picks: audit findings 1–2, BACKLOGS/002 remainder, or a real
task in a target project.

## Decisions that change the future
- goal ≡ checkpoint (renamed); no new skill; done = frontmatter status;
  goal files are units (gate covers them via touched)
- Medium tasks: one goal, one micro, no macro (minimal mode)
- Pending: audit findings 1–2; BACKLOGS/002 remainder (branch gate in
  hook, micro claim via owner:); promotion of this feature awaits
  cross-verification (LOG 015 is the verifier's input)

## Blockers
—
