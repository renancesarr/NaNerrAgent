---
name: clarify
description: >
  Analyzes the prompt before any execution: detects ambiguities that
  change the outcome, offers 3 options per ambiguity, validates
  understanding with the user. Use on every medium task (light mode) or
  large task (full mode), after classification by contain. Do not use on
  trivial tasks.
---

# clarify

## Objective
The rework of misinterpreting costs more than a 30-second question.
This skill ensures the problem is understood before wrong code exists.

## Modes
| Mode | When | How |
|---|---|---|
| light | medium task | only critical ambiguities, one round, no implicit interrogation |
| full | large task | all critical ones + implicit requirements, until explicit validation |

## What is a critical ambiguity
An ambiguity is only critical if the interpretations lead to **different
code or tests**. If both lead to the same diff, it is not an ambiguity —
it is a synonym. Do not invent questions: purposeless interrogation
creates a user who stops answering.

Detection checklist:
- term with 2+ plausible interpretations that change what gets built
- undefined scope: what is in, what is explicitly out
- missing success metric: how do we know it worked?
- conflicting requirement — with another requirement or an existing ADR
- implicit requirement: obvious to the requester, invisible to the implementer
- request collides with a unit in CATALOG.md: create new, or extend/reuse?

## Process
1. Read the prompt. Extract: objective, explicit requirements, implicit requirements.
   Repo has a CATALOG.md? Consult it for the last checklist item.
2. Run the checklist. Filter by the criticality above.
3. More than 3 critical ambiguities? Likely a misclassification — propose
   reclassifying as large (via contain) instead of interrogating in series.
4. For EACH critical ambiguity, produce 3 options:
   - **1. conservative** — most restrictive interpretation
   - **2. balanced** — middle ground
   - **3. broad** — widest interpretation
   One line per option, with the implicit cost ("broad also includes X").
5. Present the identified objective (to confirm, not presume) + numbered
   ambiguities + options + recommendation with rationale.
6. User answers with digits ("1,3") — or delegates: "you decide".
   Delegated? Apply the recommended one and mark it as an **unvalidated assumption**.
7. Choice conflicts with an existing ADR? Flag it: the choice becomes a new
   decision or an amendment — `model-domain` records it in the large pipeline.
8. Rewrite the prompt incorporating the choices. This is the **canonical
   version** — the exact input the next skill receives.
9. Record the transition (AGENTS.md §6). LOG fields for this skill:
   - `original-prompt:` verbatim
   - `clarified-prompt:` the canonical version
   - `ambiguities:` title → chosen option
   - `unvalidated assumptions:` delegations, if any

## Output format
```
## Understanding
[objective in 1–2 lines — confirmable]

## Ambiguity 1: [title]
1. conservative — [what changes]
2. balanced — [what changes]
3. broad — [what changes]
recommend: [n], because [one-line reason]

Answer with the numbers (e.g. "1,3") or "you decide".
```

## Anti-rationalization
| Excuse | Response |
|---|---|
| "It's clear enough" | Formulate 2 interpretations that produce different code. Managed? Then it's not. |
| "I'll ask mid-way if needed" | A doubt mid-way = rework of code already written; a doubt now = one message. |
| "I'll assume the obvious reading" | "Obvious" to the requester. At minimum, an unvalidated assumption in the LOG. |
| "The user will get annoyed" | Numbered options are answered with one digit. What annoys is receiving the wrong thing. |
| "I'll ask everything, it's safer" | A question that changes no code is noise. Filter by criticality. |

## Verification
- Canonical prompt validated by **explicit answer** — silence is not
  validation — or assumptions marked as unvalidated in the LOG.
- Zero critical ambiguities left listable. Truly found zero? Record "none
  found" — lazy detection is discoverable by `audit` when the code fails
  on an ambiguity that was in the prompt.
- Task with 3+ unvalidated assumptions: yellow flag — the canonical prompt
  is built on sand. Consider one more round before proceeding.
