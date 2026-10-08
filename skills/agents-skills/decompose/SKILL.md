---
name: decompose
description: >
  Splits the clarified objective into checkpoint → macro → micro-objective,
  each micro with a verifiable spec and a pre-defined objective test.
  Creates and maintains the PLAN. Use after clarify on large tasks; in
  minimal mode on medium tasks. Do not use on trivial tasks.
---

# decompose

## Objective
No task larger than one session. No micro without a definition of "done".
The rework of a boundary moved mid-way is the cost this skill avoids.

## Artifacts — distinct roles (do not confuse)
| Artifact | Mutable? | Role | Ceiling |
|---|---|---|---|
| `.context/NOW.md` | rewritten | where I AM (1 micro + next step) | 100 lines |
| `.context/PLAN.md` | mutable | the whole MAP: micros, dependencies, specs, status | — |
| `.context/log/NNN-*.md` | **never** | what HAPPENED, in order | 60 lines/entry |

A micro's spec lives in the PLAN. The LOG records the transition; the NOW points.
Specs evolve (criteria completed, adjustments) — that is why they do not live in the LOG.

## Structure
- **checkpoint** — macro-deliverable (weeks). Exists only in large tasks.
- **macro-objective** — component of a checkpoint (1–2 weeks).
- **micro** — atomic task: one session, one diff, one LOG entry.

## Micro sizing rules (verifiable, not "hours")
A micro is right-sized when ALL hold:
1. The expected diff is describable in one sentence. Can't? It's two micros.
2. It has ≤ 5 independent verifiable criteria. More? It's two micros.
3. It touches ≤ 6 units (create + modify). More? Split by unit or boundary.
4. It contains no new domain decision (that's `model-domain` first, in the large pipeline).

## Process
1. Input: the canonical prompt from `clarify`.
2. **Medium task** → minimal mode: ONE spec, no checkpoint, no macro.
   Hierarchy for a single micro is ceremony (YAGNI applied to decomposition).
3. **Large task** → list checkpoints → break into macros → break into micros.
4. Write the PLAN:

```markdown
# PLAN — [canonical objective, 1 line]

## Map
| # | micro | depends on | status | objective test (1 line) |
|---|-------|---------|--------|---------------------------|
| 1 | ...   | —       | pending| ... |
| 2 | ...   | 1       | pending| ... |

## Specs
### [1] name
objective: [1–2 lines]
criteria: [ ] ... (≤5, each independently verifiable)
dependencies: [— or micros]
units: [to create/modify, if known]
inherited assumptions: [unvalidated ones from clarification, if any]
objective test: [how a QA would validate THIS micro — command/observation]
```

5. **Spec granularity**: full map always; detailed specs only for the next
   2–3 micros; draft (objective + test, 1 line) for distant ones. A detailed
   spec for a distant micro is fiction — earlier micros invalidate its
   assumptions. Detail when its turn comes.
6. Prioritize: value first, risk early (the micro that can reveal the plan
   is wrong comes before any polish), dependencies respected.
7. **The iron rule**: if you cannot write a micro's `objective test`, the
   micro is ill-defined — you don't know what "done" is. Redefine the
   micro; never leave the field empty. `verify-objective` receiving an
   empty field sends it back here. The loop is designed to come back.
8. Record the transition. LOG: `checkpoints/macros created`, `N micros in
   the map`, `first micro + why this order`. NOW: first micro as the
   "immediate next step", pointing at the PLAN.

## Reverse diagnosis (ADR-0008/0009)
| Symptom (found later) | Cause here | Fix |
|---|---|---|
| NOW exceeds the 100-line ceiling | micro too large | go back, split the current micro |
| implement produces diff outside the spec | ill-defined micro (diff sentence impossible) | rewrite the spec before proceeding |
| verify-objective "invents" a test | empty or vague field in the spec | the fault is here, not there |

## Anti-rationalization
| Excuse | Response |
|---|---|
| "It's simple, I'll go straight ahead" | Truly simple = trivial → reclassify via contain. Medium without spec = the gate will invent its own test. |
| "I'll decompose as I go" | A boundary moved mid-way re-costs everything that already touched it. The full map exists to see dependencies BEFORE. |
| "Specs are bureaucracy" | The spec is the QA gate's contract. Without it, whoever fixes defines what "passed" means. |
| "I'll detail every spec now" | A detailed spec for a distant micro is planning fiction. Full map, just-in-time detail. |

## Verification
- [ ] Every micro in the map has: name, dependency, objective test (even as draft).
- [ ] Detailed specs (next 2–3) have ≤5 criteria and a filled objective test.
- [ ] Medium task produced ONE spec with no hierarchy. Large task has a full map.
- [ ] PLAN.md created; NOW points to it and carries only the first micro.
- [ ] No micro in the map embeds a domain decision (if it does, the large pipeline requires `model-domain` first).
