---
name: capture-human
description: >
  Converts out-of-flow human edits into knowledge: reads the why and the
  concept from .context/pending-human.md, generates the "how" from the real
  diff, records it in the LOG, reconciles NOW/goal/ADRs/docs. Runs at cold
  start of every session with a filled pending — before any task, because
  the edit may invalidate state. Does not run when pending is empty (the
  gate enforces obligation).
---

# capture-human

## Objective
Human edits enter the flow as captured knowledge, not a black hole. The
why is captured at the only moment it exists: before the commit. After
that, it becomes archaeology.

## The starting point is not the pending — it's the session window
Capture lives in `.context/log/NNN-capture-human.md` — like any transition.
The pending (`because:` + `concept:`) is the **cheap handshake with the
gate**: the two lines the pre-commit demands from a human at 3am. Handshake
≠ capture. The handshake pays minimal friction; capture pays the rest —
deferred to the agent session, where there's time and context.

## Cold start protocol (AGENTS.md §1)
Is there a pending with `because:` filled? Run before ANY task.
The edit may invalidate the NOW, a goal/ spec, an ADR, a unit doc — that is
why capture-human is the exception to the session-start rule:
**the pending is read at cold start even though it is "just" state**.
No pending → normal cold start (NOW + LOG) proceeds.

## Process
1. **Validate the gate that already ran.** The commit already passed the
   pre-commit: pending existed and was filled. Check the why matches the
   diff — a why asking "why did you change this?" with a diff that doesn't
   explain it = empty handshake, gate satisfied while capturing nothing.
2. **Get the real diff.** The human may have written "fixed the login" and
   committed 6 files. The pending is never the technical source — it's the
   complement. Diff of the corresponding commit + current state (`git
   status` — there may be uncommitted changes on top).
3. **Read because/concept verbatim.** Verbatim is a rule, not courtesy:
   agent paraphrase erases the nuance that makes the knowledge valuable.
   "The button wasn't working" ≠ "users couldn't submit".
4. **Generate the "how" connecting technique to the why.** From the diff:
   what the edit does technically, connected to the written why. The
   generated part gets a label — the human may have written wrong things;
   the agent has no way to know if "the cache was the problem" is true.
   The label preserves epistemic honesty: `[AI-generated from the diff]`
   in the how field.
5. **Record the LOG entry:**

```markdown
# NNN — capture-human (origin: manual edit)
when: [commit timestamp]
because: [human verbatim]
concept: [human verbatim]
how: [generated, connecting technique to the why — labeled]
affected units: [from the diff]
NOW impact: [none | adjustment made: ...]
ADR impact: [none | see model-domain]
doc impact: [none | see catalog]
```

6. **Cascade reconciliation** (order: living state first, dead files after):

| Action | When | Owning skill |
|---|---|---|
| NOW rewritten | the edit changes the next step | here |
| goal/ adjusted | the edit resolves/breaks a micro (status or spec) | here |
| ADR amended or superseded | the edit contradicts a decision | `model-domain` |
| Unit doc rewritten | the edit changes the contract | `catalog` |
| CATALOG updated | unit created/removed | `catalog` |

The cascade triggers skills, it doesn't execute them: each owner does its
own work under its own rules. `model-domain` decides amend vs. supersede
by its promotion test — not decided here.

7. **Broken-human fast path: "I don't know why I changed it".**
   A human without a why isn't refusal — it's the most common real case. Route:
   - agent generates 2–3 hypotheses of the why from the diff;
   - human picks or discards;
   - picked → becomes `because:` with label `[confirmed hypothesis]`;
   - all discarded → `because: [undetermined — autonomous diff]`.
   With no why at all, the commit was pure YAGNI — record and move on.
   Don't interrogate beyond that: every why has a cost, and this one already paid.
8. **Cleanup.** pending-human.md returns to empty; `.context/touched` cleaned
   (consumed). Consumed state is clean state.
9. **Record the transition** — the entry above IS the record.

## Anti-rationalization
| Excuse | Response |
|---|---|
| "Small diff, no need to capture" | The small diff with the wrong why is the expensive bug. Cost: reading 2 lines. |
| "I just sync the NOW and move on" | Without a why, the edit becomes permanent mystery — archaeology in the next audit. |
| "The why is in the commit message" | It isn't. And even if it were, no format, no existence guarantee. |
| "I'll generate the how without a label, it's cleaner" | The label separates what the human said from what the agent inferred. Without it, inference becomes fact in the LOG. |
| "Unconfirmed hypothesis is the same as no why" | It's better: it has direction, context, and can be confirmed later. The LOG has history. |
| "The edit was trivial, I skip the cascade" | Trivial for the diff, not for the state. One line of an ADR can demand full reconciliation. |

## Verification
- [ ] LOG entry with because/concept verbatim + labeled how.
- [ ] Real diff obtained and confronted with the pending (non-empty handshake).
- [ ] Cascade evaluated: NOW/goal/ADR/doc/CATALOG — impact recorded for each.
- [ ] Pending and touched cleaned after capture.
- [ ] Fast path executed when the human didn't know the why.
- [ ] Every cascade action triggered the owning skill — nothing executed "for convenience's scope".
