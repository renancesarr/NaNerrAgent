---
name: contain
description: >
  First skill of every task: classifies (trivial/medium/large) BEFORE
  executing, applies the fast path to trivia and upholds the containment
  laws throughout execution — reuse ladder, declared cuts, the never list.
  Not a pipeline stage: it's the entry door and the standing law.
---

# contain

## Objective
Bureaucracy proportional to the problem. Minimal code that works.
Contain shortens the path, never the gate. Shortens the solution, never the reading.

## Three moments, one philosophy
| Moment | What it does |
|---|---|
| entry | classifies the task and picks the path (AGENTS.md §4) |
| before code | reuse ladder — stop at the first rung that holds |
| during | containment laws + declared cuts |

## The comprehension guard
Lazy about the solution, NEVER about understanding. Read the task, the
code it touches, the real flow — only then climb the ladder. A small diff
over an unread problem is not containment: it's the most expensive bug of
all, the confident one.

## Classification — hypothesis, not verdict

| Class | Criterion | Path |
|---|---|---|
| trivial | predicted diff < 10 lines, no contract | fast path (below) |
| medium | one unit or one micro | light clarify → implement → verify-objective |
| large | changes understanding, multiple units, decision | full pipeline |

Classifying is predicting BEFORE the diff exists. Reality may falsify the
prediction — and the duty is to reclassify, not cling to the initial label.

**In-flight reclassification triggers (trivial → medium):**
- diff passed 10 lines, or touched a contract
- started touching 2+ units
- discovered it needs implements (the router)

**Action:** LOG records (`classification adjusted — reason`), the rest
follows the medium path, and closing is verify-objective over a
**retroactive minimal spec** (objective + test, two lines). A retroactive
spec is not theater: it's the price of getting the size wrong — and it's cheap.

**Downgrade** (medium → trivial) only with a recorded reason: the work
genuinely shrank (already solved / one-liner was enough). Frequent
downgrades followed by broken objectives = a pattern `audit` hunts: gate
escape through the back door.

## Trivial fast path
1 LOG line (`trivial — reason`) → minimal diff → commit.
"Done" is the end of the **pipeline**, not of the system: the commit gate,
`touched` and doc sync still apply. Touches a unit? Sync bump (catalog,
1 line). **Trivial pays little, never zero.**
Trivial does not go through `implement` — discovering it needed implement
is reclassification, not improvisation.

## The ladder (before writing code)
Stop at the FIRST rung that holds:
1. **Does it need to exist?** No → propose cancellation to the user,
   reason in one line. Need confirmed? Build it fully, **without
   re-arguing**. The best line of code is the one never written.
2. **Does it already exist?** CATALOG.md — the index exists so this rung
   costs a read, not a sweep. Re-implementing what exists a few files
   below is the most common slop.
3. **Stdlib/platform solves it?** Use. `<input type="date">` before a
   picker lib; a database constraint before app code.
4. **An installed dependency solves it?** Use. New dependency = rationale
   in the LOG (and an ADR, if it passes the promotion test).
5. **One line solves it?** One line.
6. **Only then:** the minimal code that works.

Two options of equal size? The correct one on edge cases.
Laziness is less code, not a more fragile algorithm.

## Laws during execution
- No unprompted abstraction: an interface with one implementation doesn't
  exist; a factory of one product doesn't exist; config of a value that
  never changes doesn't exist.
- Deletion > addition. Boring > clever — clever is what someone deciphers
  at 3am. Deletion follows catalog: doc goes, ADR pointers swept.
- Bug = root cause: grep EVERY caller before touching. One guard in the
  shared function is a smaller diff than one per caller — and patching
  only the ticket's path leaves the sibling broken.
- Deliberate cut with a known ceiling → `contencao:` marker, never silence.

## contencao: — declared debt
Format: `contencao: [known ceiling]; migrate when [observable trigger]`
Ex.: `contencao: global lock; migrate when contention > 5% of request time`
"Cuando it gets slow" is not a trigger, it's a mood. A trigger without a
number is not a trigger.
`audit` sweeps age and hit triggers: a declared cut is visible debt; a
silent cut is a bug with no date marked.

## Never contain
- validation at a trust boundary
- error handling that prevents data loss
- security; basic accessibility
- calibration the physical world demands (clocks drift, sensors misread)
- anything explicitly requested — user's choice wins, no re-arguing
- the gate: containment without verification is non-delivery

## State ≠ behavior — the objection answered here
Contain BEHAVIOR, not STATE. Code is what containment applies to: every
line is future maintenance. Docs, catalog, LOG, NOW are what makes
containment possible — it's the unit doc that makes ladder rung 2 cost a
read; it's the LOG that avoids re-deciding. The doc that prevents one
re-implementation has negative cost. Cutting the map to save paper
lengthens every path.

## Anti-rationalization
| Excuse | Response |
|---|---|
| "It's just a typo, I won't even classify" | The classification IS the fast path: 1 line. Skipping it is where the system leaks. |
| "I'll classify trivial, it's faster" | Trivial is a hypothesis with criteria. An 80-line diff labeled trivial is a violation audit finds in seconds. |
| "I'll only read the part I'll change" | Reading laziness is not containment — it's the confident bug. |
| "I'll keep it abstract to grow later" | YAGNI: later scaffolds for itself. |
| "I'll build it complete, more robust" | Robustness without requirement is weight with a pretty name. |
| "I'll refactor later" | Later is debt; now is minimal diff. |
| "The user asked X, but Y can be done" | Explicit request wins. Containment is an execution philosophy, not authority over requests. |

## Verification
- [ ] Classification in the LOG before execution — never reconstructed later.
- [ ] Ladder walked in order, stopping at the first rung that holds.
- [ ] Rung 1 fails → cancellation proposed, not silent construction.
- [ ] In-flight reclassification recorded when reality diverged from prediction.
- [ ] Cuts with `contencao:` have a ceiling and an observable trigger.
- [ ] Nothing from the never list was contained — including the gate.
- [ ] Fast path paid little, never zero: LOG + touched + sync.
