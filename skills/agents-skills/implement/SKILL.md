---
name: implement
description: >
  Executes a micro-objective from the PLAN: consults IMPLEMENTS-CATALOG.md,
  selects 1–3 implements-skills for the task, writes the code, triggers
  catalog before the commit and declares touched files for the gate. It is
  the ONLY gateway to implements-skills. Use for all code execution — from
  a medium task or a PLAN micro. Do not use without a spec (it does not
  execute what is undefined).
---

# implement

## Objective
Code with the right skill for the right dialect — paying only for what
this task uses. And code that enters a commit ALWAYS together with the
docs and ADRs that sustain it.

## The two laws of this skill
1. **Single gateway** (ADR-0002): implement is the only path to an
   implements-skill. No other skill — not even AGENTS.md — knows one.
   Consulting the IMPLEMENTS-CATALOG outside here violates the visibility law.
2. **No spec, no execution**: if the micro has no spec with a defined
   objective test (even a draft), go back to `decompose`. Code written
   without a definition of "done" is debt disguised as delivery.

## Internal sequence (order matters)
```
1. take the micro from the PLAN
2. validate spec against real state (below)
3. route implements
4. write code (with implements loaded)
5. TDD on units (form defined by the chosen implements)
6. trigger catalog (touched units)
7. update PLAN + NOW + LOG
8. commit (with touched declared)
```

## Step 2 — validate the spec against real state
The spec was written at an earlier moment; the world may have changed:
- Did a previous micro alter a unit this spec assumes intact?
- Was an ADR created/amended since the spec?
- Does `git status` show changes unrecorded in the NOW?

Divergence found → adjust the spec BEFORE writing code (edit the PLAN,
the LOG records the adjustment and why). A spec is the best understanding
of its time, not scripture — but code written against a stale spec is
double rework: the wrong code + the `verify-objective` finding that
sends everything back.

## Step 3 — route implements
1. Read the project's IMPLEMENTS-CATALOG.md.
2. For each entry, check: does `use when` describe this task? Does
   `don't use when` exclude it?
3. **0 selected**: a valid result. Record "none applicable because
   [reason]" — and catalog it as a **candidate** in IMPLEMENTS-CATALOG
   (a skill that doesn't exist yet but that this task would need).
4. **1–3 selected**: load them. More than 3 = a sign the task is too
   large for one session — consider going back to `decompose`.
5. Record in the LOG: `implements: [skills] + why each one`.

### Why 1–3 (the logic, not the number)
Loading a skill has cost and benefit. A well-decomposed task rarely needs
more than 3 simultaneous dialects (e.g. test-rust + api-patterns).
If it needs 4+, the micro wasn't a micro — it was a macro in disguise.

## Step 4 — write code
Follow the loaded implements for the project's dialect, conventions and
patterns. With no applicable implements, follow the laws of AGENTS.md §2
and the language's good sense. Implementation follows the spec;
divergences discovered while writing (technical impossibility, unexpected
dependency) → adjust the spec first (same rule as step 2), then the code.

## Step 5 — TDD on units (internal hygiene, AGENTS.md §5)
The testing implements-skill defines the FORM (framework, patterns, names).
The discipline is fixed: red → green → refactor, on logic units.
No unit tests for trivial work (contain classifies; a typo generates no
suite). The delivery gate is the OBJECTIVE test — that's `verify-objective`,
not here. Here: the unit works in isolation and branching logic
(branches, loops, parsing, money/security) has an executable check.

## Step 6 — trigger catalog
Every touched unit needs synced docs before the commit.
`catalog` does the work; here it's enough to guarantee it runs BEFORE
the commit — never after. Fixed sequence: code → catalog → commit.

## Step 7 — update PLAN + NOW + LOG
- **PLAN**: micro marked `done` (or `in-progress` if it broke mid-way).
- **NOW**: rewritten — next micro as the "immediate next step";
  if it broke mid-way, the partial state (what's done, what's missing,
  exactly where it stopped).
- **LOG**: entry with `micro`, `implements + why`, `diff summary`
  (1–3 lines, not the whole diff — git already has it), `sync` (what
  catalog declared).

## Step 8 — commit
1. Declare the files the commit will contain in `.context/touched`
   (units + docs + PLAN + NOW + LOG — everything going into the commit).
2. Commit. The pre-commit compares staged vs touched (AGENTS.md §7).
3. Divergence = block. If the agent forgot to declare something,
   adjust `touched` and re-commit. Do not circumvent the gate.

## Micro that doesn't fit in one session
Ran out of time/context mid-way? Don't force the finish. Record in the NOW:
- what is done (units, partial diff)
- what is missing (remaining spec steps)
- exactly where it stopped (not "mid-way" — the concrete next step)

The next agent resumes from the NOW. A well-decomposed micro badly
executed is recoverable; a micro forced at session end is possibly broken
code that looks done.

## Anti-rationalization
| Excuse | Response |
|---|---|
| "I'll load all implements, it's safer" | That's ECC-mode: everything always available = agent always lost. Explicit selection is the design. |
| "Stale spec, I'll follow it anyway" | Code against a stale spec = double rework. Adjusting the spec costs 2 lines in the PLAN. |
| "Catalog after the commit" | The gate blocks it. And if it didn't: doc later is doc never. |
| "I'll finish the micro, it's almost there" | Almost = it isn't. Partial state in the NOW is recoverable; broken-looking-done is not. |
| "One extra implement won't hurt" | Every loaded skill is context competing with the task. If it wasn't selected with a why, it doesn't enter. |

## Verification
- [ ] Spec validated against real state before code (LOG records the adjustment or "no divergence").
- [ ] Implements selection recorded with per-skill rationale (or "none because...").
- [ ] Every unit in the commit has synced docs (catalog ran before the commit).
- [ ] `.context/touched` declares everything committed (the gate passes).
- [ ] NOW rewritten: next micro or explicit partial state.
- [ ] LOG has an entry with micro, implements, diff summary, sync.
