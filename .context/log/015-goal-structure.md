# 015 — implement BACKLOGS/001: goal/ persistent objectives (large)
when: 2026-10-08
input: user request — implement backlog 001 (the goal/ folder)
classification (conter, BEFORE): large — changes understanding (specs
       leave PLAN.md for a persistent tree), several units, domain
       decision → ADR-0012. Pipeline: clarify(openings resolved via
       laws) → decompose(dogfood in goal/001) → model-domain(ADR-0012)
       → implement → verify-objective.
openings resolved (recorded in ADR-0012): goal≡checkpoint rename; no new
       skill (decompose absorbs); done=status in frontmatter, file stays;
       ADR required and written.
implements: none applicable — docs/skill amendments + dogfood tree
output: goal/001-goal-structure/ (GOAL.md + 3 micros, all done),
       ADR-0012 + ADR-CATALOG line, decompose rewritten (goal/ artifacts,
       optional macro, status contract), implement/verify-objective/
       audit/capture-human amended, CATALOG +goal/ line, BACKLOGS/001 →
       status: implemented, NOW with active-micro PATH.

## Evidence (verify-objective)
  $ grep -rn "PLAN" skills/ AGENTS.md hooks/ installer/ → only the
    "PLAN.md retired" mentions in ADR prose; 0 living references
  $ grep -A2 "Immediate next step" .context/NOW.md → prints the micro
    PATH (goal/001-goal-structure/003-dogfood-and-verify.md) — active
    micro found in ONE read
  $ grep -l "status: done" goal/001-goal-structure/*.md → 3 micros whose
    status flipped pending→done WITHOUT editing any LOG file (append-only
    preserved; the flip is visible in git history of the micro files)
  $ installer/test-install.sh → 20/20 (regression: system intact)
acceptance criteria from BACKLOGS/001: [x] decompose amended pointing
  goal/ as spec home [x] active micro in 1 read [x] status mutable
  without LOG edits [x] gate covers goal/ (touched declares goal files)
  [x] CATALOG indexes the goal
note: per ADR-0012 the macro level is optional — single-component goals
  put micros next to GOAL.md (deviation from backlog v2 tree, justified
  as YAGNI inside the ADR)
next: cross-verification of feature/goal-structure by another agent (or
  user authorization, as in LOG 014); then audit findings 1–2 / 002 rest
