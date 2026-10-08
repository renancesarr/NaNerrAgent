---
name: catalog
description: >
  Maintains the index of what exists: one line per unit in CATALOG.md, a
  context .md per unit, bidirectional links with ADRs — synchronized in
  the same commit as the code. Invoked by implement before every commit
  that touches a unit; by model-domain when re-linking; by capture-human
  and audit during maintenance. Never runs alone.
---

# catalog

## Objective
The agent discovers what exists by reading an index, not the whole code.
This skill keeps the index true — and is the **unit** half of the ADR
link (the **decision** half is `model-domain`): model-domain cares for
how the system speaks and decides; catalog, for what it is.

## The central invariant (no exceptions)
> **Unit staged → its .md staged. In the same commit.**

The fast path lowers the COST of syncing, never the obligation.
Exceptions are where gates rot: the first breach becomes the second in two weeks.

## What is a unit
| Is | Is not |
|---|---|
| code file with its own behavior (ADR-0001) | lockfile, generated artifact, build |
| concept-folder (Go package, Rust mod, Python pkg) → `UNIT.md` inside | config without logic (declare in the LOG, no doc) |

Test: **would a future task need to read this to decide something?**
Yes → unit. No → not cataloged. Same test as `clarify`: what changes no
future decision is noise.

## Artifacts and template
`CATALOG.md`: `| path | responsibility in 1 line |`, sections per directory.
The catalog points; it never duplicates the doc's content (DRY).

Unit doc (`<name>.md` next to the file; `UNIT.md` for a unit-folder):

```markdown
---
unit: path/relative/to/repo
decisions: [ADR-NNN, ...]
last-sync: YYYY-MM-DD
---
# [name]
responsibility: [1–2 sentences]
interface: [what's public, minimal signature — if it exposes anything]
dependencies: [units and ADRs]
example: [minimal real usage — when it helps]
notes: [what the next reader needs and can't see in the signature]
```

Ceiling: **~40 lines**. A doc that systematically overflows = unit too
large — same logic as the NOW ceiling: the symptom points to the root
cause one step back, not at the writing.

## Process — per entry point
| Trigger | Origin | Action |
|---|---|---|
| upcoming commit | `implement` | sync every touched unit (below) |
| re-linking | `model-domain` | update `decisions` in frontmatter |
| human edit | `capture-human` | doc invalidated → rewrite affected sections |
| detected drift | `audit` | the fix flows through here — audit only reports |
| existing repo | bootstrap | catalog-on-touch (below) |

## Sync — three levels (the common case)
When closing a diff on a unit:
1. **contract changed** (interface, parameters, promised behavior):
   update interface/dependencies/notes + `last-sync`.
2. **internals changed, contract same**: notes if something relevant + sync.
3. **nothing relevant** (typo, formatting): `last-sync` + a
   `contract unchanged` declaration. It's 1 line — trivial pays little,
   never zero.

The declaration lives in the transition's LOG entry:
`sync: path → contract unchanged | interface updated ([what]) | doc created`.

`audit` checks `last-sync` against `git log -1 -- <unit>`:
doc date < last commit date on the unit = drift.

## Create · delete · rename
- **Create**: doc + CATALOG line + `decisions` with existing ADRs that
  sustain it (the other side is `model-domain`).
- **Delete**: remove doc, remove line, **sweep ADR-CATALOG for pointers to
  the unit** — found any → trigger `model-domain` (re-link or orphan).
- **Rename/move**: move the doc along, update path in CATALOG and in linked
  ADRs, adjust references in NOW/PLAN. An expensive rename is the price of
  a trustworthy index — record it in the LOG and move on.

## Brownfield — catalog-on-touch
An existing repo without a catalog is NOT cataloged all at once.
Catalog what you touch; the index grows where usage proves the entry is
needed. Full cataloging is an explicit task (classified by `contain` as
large) — and in most repos it's YAGNI.

## Handshake with the gate
Docs and CATALOG go into `.context/touched` together with the units.
The pre-commit verifies the invariant; this skill guarantees the state that passes.

## Anti-rationalization
| Excuse | Response |
|---|---|
| "Small file, explains itself" | The catalog is for the agent that NEVER opened this file. |
| "I'll update the doc at the end" | The end of what? Every commit is a valid state or it isn't. |
| "Only internal changes" | Then declare contract unchanged — 1 line. Without the declaration, an auditor can't tell laziness from forgetting. |
| "A complete doc is better" | Nobody reads a 200-line doc — and the unread one rots first. |
| "I'll catalog the whole repo" | Catalog-on-touch. A doc written without immediate need rots before first use. |
| "Deletion needs no ceremony" | A dead line in the index = an agent trusting a ghost. Worse than no index. |

## Verification
- [ ] Every staged unit has its .md staged (trivial: with a sync bump).
- [ ] Created unit: CATALOG line + frontmatter with correct `decisions`.
- [ ] Frontmatter `decisions` ↔ ADR `units` — matching on both sides.
- [ ] `last-sync` = today for every touched doc.
- [ ] Deletion/rename: CATALOG and ADR pointers adjusted.
- [ ] Docs ≤ ~40 lines; CATALOG points, never duplicates.
