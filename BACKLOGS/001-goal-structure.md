---
id: 001
status: implemented
type: future-implementation
target-units: [skills/agents-skills/decompose, CATALOG.md, .context/NOW.md]
created: 2026-10-08
source: user request (LOG 003)
---
# `goal/` folder — persistent objectives in a macro/micro tree

## Objective
Give objectives a permanent address: the decomposition (today narrated only
in the LOG) becomes a navigable folder tree — goal → macro → micro — with
mutable state (status) without breaking the append-only LOG.

## Reason
- `decompose` produces checkpoint/macro/micro, but the specs live only in the
  LOG; there is nowhere to update the status of a micro without rewriting
  the past.
- The agent needs to find "the active micro" in 1 read — same ruler as the
  CATALOG.

## Original proposal (from the user)
```
goal/
└── 001-<slug-1-2-words>/
    ├── GOAL.md
    └── macro-goal/
        └── 001/
            ├── MACRO-GOAL.md
            └── 001-microgoal-<slug>.md
```

## Improved structure (v2 — proposal)
```
goal/
└── 001-<slug-1-2-words>/
    ├── GOAL.md            # objective, criteria, objective test, status
    └── macro/
        └── 001-<slug>/
            ├── MACRO-GOAL.md      # macro spec: objective + acceptance criteria
            ├── 001-<micro-slug>.md
            └── 002-<micro-slug>.md
```

## Improvements over the original proposal
| # | Change | Why |
|---|---|---|
| 1 | `NNN-slug` at macro level (not just `001`) | orders AND names; a pure number doesn't scale |
| 2 | micro = `.md` file, not folder | a micro is atomic (hours); a folder for 1 file is ceremony |
| 3 | `macro/` (not `macro-goal/`) | the level is already under goal/; a repeated name is noise |
| 4 | `GOAL.md`/`MACRO-GOAL.md` with `status` + `decisions` frontmatter | bidirectional link with ADRs, like every unit (catalog) |
| 5 | kebab-case slug; numbering restarts per folder | local scope, no global counter to maintain |

## Integration with the existing system
- **decompose** (amend the skill): micro specs now live in `goal/`;
  the LOG records the pointer, not the content.
- **NOW**: "immediate next step" references the active micro by path.
- **CATALOG**: `goal/` indexed (1 line per goal; its own index if it grows).
- **gate**: `goal/*.md` are units — a commit touching them touches
  doc/status in the same commit.

## Open questions (decide at implementation)
1. `goal` ≡ `checkpoint` (rename the term in decompose) or a new level above?
2. Is `GOAL.md` written by `decompose` directly, or does a `goal` skill emerge?
3. Completed goals: `goal/done/`, `status: completed` in the frontmatter, or removal?
4. Does it need an ADR? (decision: specs leave the LOG and get a home with
   mutable state)

## Acceptance criteria (QA of the implementation)
- [ ] `decompose` amended pointing to `goal/` as the home of specs
- [ ] finding "the active micro" = 1 read (NOW → path → file)
- [ ] micro status updatable without editing the LOG (append-only preserved)
- [ ] gate covers `goal/` (touched/because) and CATALOG indexes the new goal
