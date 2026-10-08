---
name: model-domain
description: >
  Maintains the ubiquitous language (GLOSSARY.md) and the project's ADRs:
  correct granularity, indexed catalog, bidirectional links to units. It
  is a stage of the large pipeline when there is a domain decision — and
  an on-demand maintenance skill when clarify detects an ADR conflict,
  capture-human invalidates a decision, or audit finds broken links. Do
  not use on trivial tasks.
---

# model-domain

## Objective
A term means one thing only. A decision with a lasting trade-off has an
address, historically traceable — including the decisions we regret.

## Two repositories, two rhythms
| Artifact | Rhythm | Cost | Cares for |
|---|---|---|---|
| `GLOSSARY.md` | continuous, fast path | 1 line per term | how the system SPEAKS |
| `docs/adr/NNN-*.md` + `ADR-CATALOG.md` | per decision | ~50 lines each | how the system DECIDES |

## Granularity — the promotion test (this skill's central ruler)
Decisions are born in the LOG of every execution. The question is when
one becomes an ADR:

> **If a fresh agent, working on a DIFFERENT unit than this one, would
> make a different decision without knowing this → ADR.**
> If it only affects the current unit/task → it stays in the LOG. Period.

The two symmetrical failures this test avoids:
- **Explosion**: every local decision becoming an ADR (40 ADRs in a small
  system = someone documented non-decisions).
- **Starvation**: a domain decision rotting in the LOG, discovered by
  archaeology in the next bug it caused.

## Glossary — process
1. New or inconsistently used term? **Check the glossary before minting**:
   a synonym already exists → reuse it. Synonymy is vocabulary's DRY; every
   new synonym is a term the agent pays twice for not finding.
2. Entry: `**term** — one-line definition (synonyms: ...)`.
3. Definition doesn't fit one line? The term is playing two roles — split
   into two terms, or the domain boundary is badly cut.
4. Term unused in code/docs → mark orphan; removal proposed in the next
   audit.
5. Fast path: term alone, no decision → 1 line in the LOG. No ceremony.

## ADR — amend vs. supersede (ruler)
| Situation | Action | Why |
|---|---|---|
| detail/consequence learned; the **choice stays the same** | **amend** in place: edit the section, status stays `accepted`, LOG records what changed | the decision did not change; the understanding of it matured |
| the **choice inverts** (the alternative we rejected starts winning) | **new ADR** with `supersedes: NNN`; old one → `status: superseded`; units re-linked to the new one | amending in place would erase the original why — and the why of having been wrong is the most valuable archaeology there is |

Supersede is the append-only LOG applied to decisions: the past is never
rewritten, it is pointed at by a successor.

## ADR — process
1. Passed the promotion test? Create `docs/adr/NNN-slug.md` (sequential NNN):

```markdown
---
id: NNN
status: accepted      # accepted | superseded
supersedes: —         # ADR-NNN when this one supersedes
units: [paths of the units that sustain it]
---
# [decision in one sentence]

## context
[what pressure motivated it]

## alternatives
[the ones considered, with each one's downside — minimum 2]

## consequences
[what we gain, what we give up]
```

2. Body ≤ ~50 lines, one screen. Over? It's two decisions — split it.
3. Line in `ADR-CATALOG.md`: `| NNN | status | decision in 1 line | units |` —
   in the same commit (same law as AGENTS.md §7).
4. **Linking, clear owners**: this skill maintains the ADR side (`units`
   field) and **triggers `catalog`** for the unit side (`decisions`
   frontmatter). The bidirectional link does not violate DRY: pointers are
   navigation; knowledge lives once — in the ADR.
5. Done: record the transition. LOG: `ADR NNN created/superseded/amended + why`,
   `terms added/adjusted`.

## Entry points (the only core skill that is both stage AND maintenance)
| Trigger | Origin | Action |
|---|---|---|
| large pipeline | `decompose` found a micro with an embedded decision | ADR before final specs |
| clarification conflict | `clarify` step 7: choice contradicts an ADR | validated choice → amend or new ADR |
| human edit | `capture-human`: diff invalidates a decision | reconcile + re-link units |
| audit | `audit`: orphans, stale links | fix catalog and links |

## DDD-lite — where it stops
Yes: ubiquitous language, traceable decisions, boundaries by domain.
No: formal bounded contexts, aggregates, domain events, ceremony.
CRUD is CRUD. Forcing DDD onto CRUD produces the dead-archive this system exists to kill.

## Anti-rationalization
| Excuse | Response |
|---|---|
| "I decide and document later" | Later never comes; the decision becomes archaeology in the next bug. |
| "It's a technical detail, not an ADR" | Then it's a code comment — confirm the granularity, don't skip the record. |
| "The decision is obvious" | Obvious until the bug that reverts it. Real alternatives and lasting consequence? Passed the promotion test? Not obvious. |
| "I'll amend directly, it's faster" | If the choice inverted, amending erases the original why. Today's saving costs tomorrow's archaeology. |
| "Every decision deserves an ADR" | Promotion test: affects ANOTHER unit? No? LOG. 40 ADRs in a small system is nobody reading any. |
| "I'll mint the term when I need it" | Checked the glossary? A new synonym is duplicated vocabulary — the agent pays to not find it. |

## Verification
- [ ] An ADR without `alternatives` with ≥ 2 real options = invalid.
- [ ] A superseded ADR points to its successor AND the successor points
      `supersedes` — bidirectional catalog.
- [ ] Unit linked only to a `superseded` ADR = stale link; re-link.
- [ ] Glossary term with 2 meanings in code = failure of this skill.
- [ ] Every new ADR has an ADR-CATALOG line in the same commit.
- [ ] Every promoted decision passed the promotion test — recorded in the
      LOG ("promoted because it affects ...").
