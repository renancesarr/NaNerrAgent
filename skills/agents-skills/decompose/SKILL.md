---
name: decompose
description: >
  Splits the clarified objective into goal → (macro) → micro-objective
  inside the persistent goal/ tree, each micro with a verifiable spec and
  a pre-defined objective test. Use after clarify on large tasks; in
  minimal mode on medium tasks. Do not use on trivial tasks.
---

# decompose

## Objective
No task larger than one session. No micro without a definition of "done".
The rework of a boundary moved mid-way is the cost this skill avoids.

## Artifacts — distinct roles (do not confuse)
| Artifact | Mutable? | Role | Ceiling |
|---|---|---|---|
| `goal/NNN-slug/GOAL.md` | mutable | the objective: success metric + map of micros/macros with status | 100 lines |
| `goal/NNN-slug/NNN-slug.md` (micro) | mutable | one micro's spec + `status` frontmatter | 60 lines |
| `.context/NOW.md` | rewritten | where I AM (active micro path + next step) | 100 lines |
| `.context/log/NNN-*.md` | **never** | what HAPPENED, in order | 60 lines/entry |

The spec of a micro lives in its goal/ file. The LOG records transitions
and pointers; the NOW points at the active micro's path. Specs evolve
(criteria checked, adjustments) — that is why they live in goal/, not in
the append-only LOG (ADR-0012).

## Single home for objectives (ADR-0013)
Objectives are minted ONLY into goal/. A vision doc (IDEA.md, README) is
optional context — problem, mechanisms, metrics, non-goals — and NEVER a
second objective list: if it states objectives, extract them into goal/
and leave the vision behind. Neither artifact requires the other; when
objectives exist, goals are the authority.

## Structure
- **goal** — the persistent objective (was "checkpoint"; renamed by
  ADR-0012): a folder `goal/NNN-slug/` with GOAL.md. Survives sessions.
- **macro** — component of a goal (1–2 weeks). OPTIONAL: a single-
  component goal puts its micros directly under the goal folder; create
  `macro/NNN-slug/MACRO-GOAL.md` only when the goal has multiple
  components worth naming (YAGNI applied to the tree itself).
- **micro** — atomic task: one session, one diff, one LOG entry. A file
  `NNN-slug.md` with frontmatter.

## Micro frontmatter — status is the contract
```markdown
---
status: pending | in-progress | implemented | done | abandoned
owner: <agent>        # optional; the BACKLOGS/002 claim (dono:)
---
```
- `done` is written ONLY by verify-objective (execution doesn't attest
  delivery).
- `abandoned` releases a claimed micro (BACKLOGS/002).

## Micro sizing rules (verifiable, not "hours")
A micro is right-sized when ALL hold:
1. The expected diff is describable in one sentence. Can't? It's two micros.
2. It has ≤ 5 independent verifiable criteria. More? It's two micros.
3. It touches ≤ 6 units (create + modify). More? Split by unit or boundary.
4. It contains no new domain decision (that's `model-domain` first, in the large pipeline).

## Process
1. Input: the canonical prompt from `clarify`.
2. **Medium task** → minimal mode: ONE goal with ONE micro file, no macro.
   Hierarchy for a single micro is ceremony (YAGNI applied to decomposition).
3. **Large task** → create `goal/NNN-slug/` (next NNN): GOAL.md with
   objective, success metric and the map; break into macros ONLY if
   multiple named components exist; break into micro files.
4. Micro spec template:

```markdown
---
status: pending
---
# NNN — [name]
objective: [1–2 lines]
criteria: [ ] ... (≤5, each independently verifiable)
dependencies: [— or micros]
units: [to create/modify, if known]
inherited assumptions: [unvalidated ones from clarification, if any]
objective test: [how a QA would validate THIS micro — command/observation]
```

5. **Spec granularity**: full map in GOAL.md always; detailed specs only
   for the next 2–3 micros; draft (objective + test, 1 line) for distant
   ones. A detailed spec for a distant micro is fiction — earlier micros
   invalidate its assumptions. Detail when its turn comes.
6. Prioritize: value first, risk early (the micro that can reveal the plan
   is wrong comes before any polish), dependencies respected.
7. **The iron rule**: if you cannot write a micro's `objective test`, the
   micro is ill-defined — you don't know what "done" is. Redefine the
   micro; never leave the field empty. `verify-objective` receiving an
   empty field sends it back here. The loop is designed to come back.
8. Record the transition. LOG: `goal NNN created`, `N micros in the map`,
   `first micro + why this order`. NOW: the active micro's PATH as the
   "immediate next step". CATALOG: one line per goal folder (catalog).

## Reverse diagnosis (ADR-0008/0009)
| Symptom (found later) | Cause here | Fix |
|---|---|---|
| NOW exceeds the 100-line ceiling | micro too large | go back, split the current micro |
| implement produces diff outside the spec | ill-defined micro (diff sentence impossible) | rewrite the spec before proceeding |
| verify-objective "invents" a test | empty or vague field in the spec | the fault is here, not there |
| GOAL.md exceeds the ceiling | goal doing two goals' work | split into two goal folders |

## Anti-rationalization
| Excuse | Response |
|---|---|
| "It's simple, I'll go straight ahead" | Truly simple = trivial → reclassify via contain. Medium without spec = the gate will invent its own test. |
| "I'll decompose as I go" | A boundary moved mid-way re-costs everything that already touched it. The full map exists to see dependencies BEFORE. |
| "Specs are bureaucracy" | The spec is the QA gate's contract. Without it, whoever fixes defines what "passed" means. |
| "I'll detail every spec now" | A detailed spec for a distant micro is planning fiction. Full map, just-in-time detail. |
| "Every goal needs macros" | Macro is optional by design (ADR-0012). Naming a single component is ceremony. |

## Verification
- [ ] Every micro in the map has: name, dependency, objective test (even as draft).
- [ ] Detailed specs (next 2–3) have ≤5 criteria and a filled objective test.
- [ ] Medium task produced ONE goal with ONE micro, no macro. Large task has a full map.
- [ ] GOAL.md created with success metric; NOW carries the active micro's PATH.
- [ ] No micro in the map embeds a domain decision (if it does, the large pipeline requires `model-domain` first).
