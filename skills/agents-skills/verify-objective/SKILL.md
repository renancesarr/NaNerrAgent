---
name: verify-objective
description: >
  The delivery gate (ADR-0005): validates micro and objective the way a QA
  would test — behavior, integration, acceptance, with recorded executable
  evidence. The spec is the oracle; the code is a black box. Runs on
  closing every micro (implemented → done) and on closing the whole
  objective. Does not run on trivia — contain already exempted them.
---

# verify-objective

## Objective
Prove that what was asked happened — with reproducible evidence, never
assertion. This skill is the gate: nothing delivers without passing it.

## Fixed hierarchy (AGENTS.md §5)
| Evidence | Value |
|---|---|
| OBJECTIVE test passing, with evidence | **delivery gate** |
| green unit tests (TDD) | internal hygiene |
| "I analyzed the code, it's correct" | not evidence |

Green unit tests + broken objective = FAILED. No appeal.

## Black box — the oracle is the spec, never the code
Whoever wrote the code has confirmation bias; the defense is structural:
- `expected:` derives from the spec and is written BEFORE executing.
- Read the code to find out what to expect? You tested the code against
  itself — a tautology, not verification.
- The LOG records `expected / got / result` per criterion. Expected
  identical to got in 100% of history is sniffable by `audit`.

## Two scopes
| Scope | Oracle | When |
|---|---|---|
| micro-gate | micro spec: objective test + criteria | every implemented micro |
| objective-gate | canonical prompt (clarify LOG) + delegated assumptions | last micro green |

The objective-gate exists because **the sum of green micros ≠ delivered
objective** — the classic failure: everything green, the system doesn't do
the thing. Test against the request, not against the sum of parts.

## Valid forms (the form varies per project; the requirement doesn't)
1. **executable** — command + output, re-runnable (flaky = fail)
2. **instrumented interactive** — steps + recorded observations
3. **prepared for human** — agent delivers steps + expected; the human
   executes and reports. Status `pending-verification` until the report.
   Prepared is never passed. Never.

## Process
1. Micro-gate: reread the spec. `objective test` empty or vague?
   → **go back to decompose** (the iron rule there). Don't invent the test
   now: a test invented on the spot tests what the code does, not what was asked.
2. Write `expected:` for each criterion — from the spec, before executing.
3. Execute the objective test against the real state (committed/staged).
   Record `got:` and `result: pass|fail` per criterion.
4. Rejection checklist (any item fails it):
   - [ ] tested as behavior, not structure
   - [ ] error paths exercised: invalid input, boundary, empty
   - [ ] integration between the micro's units exercised, not just isolated
   - [ ] reproducible evidence in the LOG
5. **Failed → three routes, never silence:**
   | Cause | Route |
   |---|---|
   | bug in the code | fix (implement scope), re-run the gate |
   | mechanical bug in the test | fix the test, re-run |
   | wrong expectation | that's a SPEC CHANGE: edit the micro's goal/ file + record in the LOG |
   Changing the expected silently to make the test pass is how every gate rots.
6. **Same criterion fails for the 3rd time → STOP.** The problem is
   upstream: bad spec, wrong approach, micro too large. Go back to
   decompose/contain carrying the failure record. An infinite patch loop
   is debt with interest.
7. Objective-gate: reread the canonical prompt in the clarify LOG. Verify
   the delivery against IT. **A delegated assumption that turned structural**
   is exposed at delivery: "you delegated X; we built on X; confirm". The
   loop that clarify opened, this closes.
8. Green → the micro's goal/ file: frontmatter `status: done` — a status
   only this skill writes (implement marks `implemented`; execution doesn't
   attest delivery). Failed → NOW returns to the micro in rework. The gate
   runs on real state: failure becomes a fix commit — honest history, no
   hidden commit.
9. Record the transition (AGENTS.md §6): commands, expected/got, verdict.

## Diagnosis: absence of failures is a symptom
A verification LOG with 100% pass from the start = expected pasted from
got, or a test too trivial to fail. Occasional failures are the evidence
of honest verification. `audit` checks this.

## Anti-rationalization
| Excuse | Response |
|---|---|
| "All unit tests green" | §5 hierarchy: green on the wrong step doesn't deliver. |
| "Testing the objective is expensive" | More expensive: the user finding out. |
| "I'll validate manually later" | "Later" is where objectives die (AGENTS.md §5). |
| "I read the code, it's right" | Broken black box = tautology. The spec is the oracle. |
| "The test failed, I'll adjust the expected" | Expected is spec. The right route is in step 5 — silently, never. |
| "It failed again, one more try" | 3rd failure of the same criterion = upstream. Stop and diagnose. |
| "I prepared the steps for the user" | Prepared ≠ executed. pending-verification until the report. |

## Verification
- [ ] `expected:` recorded before execution, for every criterion.
- [ ] Executable evidence or recorded observation — assertion doesn't count.
- [ ] Errors and integration exercised, not just the happy path.
- [ ] Every failure routed (code/test/spec) — zero expected changed silently.
- [ ] No criterion passed the 3rd failure without stopping and diagnosing.
- [ ] Objective-gate tested against the canonical prompt; delegated assumptions exposed.
- [ ] `done` in the micro's goal/ file was written by this skill — and nothing else.
