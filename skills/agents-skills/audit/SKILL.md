---
name: audit
description: >
  On-demand diagnosis with evidence: mechanical integrity sweeps (drift,
  orphans, ceilings, suspicious patterns) and sequential forensic reading of
  the LOG to locate where execution degraded. Reports with severity and
  citable evidence; does not remediate in the same breath. Explicitly
  invoked — never automatic. The only skill that reads the historical file,
  not the state.
---

# audit

## Objective
Answer "where did the process fail" with a LOG entry in hand, not a guess.
Every skill in the system declared how it fails; here those signatures converge.

## Two scopes, two costs
| Scope | What it does | Cost | When |
|---|---|---|---|
| sweep | mechanical, greppable checks | low | mild symptom, routine |
| forensic | LOG in sequence until the divergence | high | quality dropped, wrong delivery, rework |

With a symptom: sweep + forensic of the suspect objective — paginated via
the objectives catalog, which exists for this. Full forensic (whole LOG,
every objective) is the last resort, never the first: reading the past is
expensive, and cheap precisely because it's on demand.

## Triage — symptom → first place to look
| Symptom | First stop |
|---|---|
| "delivered wrong" | clarify LOG (unvalidated assumptions) + verify-objective (expected/got) |
| rework growing | in-flight reclassifications, downgrades, retroactive specs |
| "agent ignores the rules" | which LOG field is systematically missing → owning skill |
| NOW bursting the ceiling | decompose: micro size |
| stale doc | sync sweep; implement skipped step 6 |
| out-of-flow commit | commit↔touched divergence without pending = gate bypass |

## Sweep (the 8 checks)
1. **Drift**: doc `last-sync` < `git log -1 -- <unit>` → stale doc.
2. **Bidirectional orphans**: CATALOG↔files · ADR↔units (frontmatter
   `decisions` ↔ `units` field) · GLOSSARY terms without usage.
3. **Ceilings**: NOW>100 · doc>40 · LOG entry>60 · ADR>50. Systematic
   overflow points upstream — not a writing problem.
4. **LOG patterns**: 100% pass from the start · expected==got always ·
   trivial with large diff · downgrades followed by broken objective ·
   repeated "zero ambiguities" · ≥3 unvalidated assumptions per task.
5. **contencao:** age + trigger already hit and not migrated.
6. **stale pending-human**: existing for more than one session = cold
   starts skipping AGENTS.md §1 — the system's worst silent hole.
7. **PLAN**: `done` written by non-gate · eternal `pending-verification`
   (the human never reported — the debt stays open forever).
8. **Gate bypass**: commit with files outside `touched` and no pending =
   `--no-verify`. The gate was circumvented; the evidence stays in history.

## Forensic — the guiding question
For each transition in the objective's LOG, in order:
- was the declared input what was actually received (against the artifacts)?
- was the declared output actually produced (against git/files)?
- are the owning skill's required fields present?

> **At which transition did the divergence start?**
> The FIRST one is the failure; everything after is cascade. Fixing
> cascade without finding the first divergence is symptom patching — the
> sibling bug stays waiting. (It's `contain`'s law — root cause — applied
> to the process itself.)

## Severity
| Level | Definition |
|---|---|
| **critical** | the state LIES: ghost-state, expected changed silently, `done` without gate, bypass, unprocessed pending |
| **major** | mechanism ignored: missing LOG fields, no prior classification, no expected-before-got |
| **minor** | hygiene: drift, orphans, ceilings, format |

State that contradicts reality is worse than absent state: absent costs a
reading; lying costs a wrong decision.

## Report
`docs/audits/NNN-[scope].md`:

```markdown
# Audit NNN — [scope] — [date]
trigger: [symptom that fired it]
## Findings
| # | sev. | finding | evidence (LOG/file+line) | probable cause | minimal fix | owning skill |
|---|---|---|---|---|---|---|
## Conclusion
[where degradation started — or "no degradation; X is suspect because Y"]
```

## Discipline — diagnosis, not remediation
- A finding without citable evidence is not a finding, it's an opinion.
- **Don't fix in the same breath.** Sole exception: a trivial 1-line fix
  (missing catalog line), recorded as `audit-fix` in the LOG.
  Fixing during an audit destroys the crime scene.
- Findings route to the owning skill — the fix is reinforcing/applying
  that skill's verification, never "conveniently" fixing here.
- An audit is a transition: LOG entry pointing at the report.

## Anti-rationalization
| Excuse | Response |
|---|---|
| "Overall it's fine" | Did the sweep run? Citable findings? "Overall" without evidence is opinion — this skill's rule. |
| "I'll fix as I find" | Mixing diagnosis with remediation destroys evidence. 1 line, at most, logged. |
| "LOG too big to read" | That IS a finding — and it's why forensic is on demand and paginated by objective. |
| "I remember what happened" | Session memory is exactly what an audit cannot use. Evidence or it didn't happen. |
| "No findings — perfect audit" | Nine mechanisms with total compliance from day 1 is fiction. No findings = shallow sweep or condescending reading. |

## Verification
- [ ] Every finding cites a LOG entry or file+line — no exceptions.
- [ ] Severity assigned; owning skill routed; minimal fix proposed.
- [ ] Report saved in docs/audits/ and pointed to by the LOG entry.
- [ ] No non-trivial fix executed during the audit.
- [ ] Forensic pointed at the FIRST divergence, not the most visible.
- [ ] Sweep covered the 8 checks — skipped one? Recorded which and why.
