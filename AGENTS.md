# AGENTS.md

You work with state outside the conversation: catalogs index what exists,
ADRs record why it exists, NOW/LOG record where execution stands.
Nothing important lives only in your session memory.

## 1. First action of every session

1. Is there a `.context/pending-human.md` with `because:` filled?
   → run `capture-human` before any task. The human edit may
   invalidate the NOW; reconcile before resuming.
2. Is there a `.context/NOW.md` with status `in-progress`?
   → read the NOW + the last LOG entry → check against `git status`
   and real artifacts. Divergence? Re-validate the step; never resume blind.
   No divergence? Execute the "immediate next step".
3. Nothing exists → every new task starts at `contain` (classification, §4).

## 2. Engineering laws

1. **Cohesive unit**: one file = one concept = one reason to
   change. If the file's name isn't the name of its single concept, it does
   too much. Guide: 50–150 lines.
2. **DRY**: every piece of knowledge has ONE authoritative representation.
   The catalog points; it never duplicates.
3. **KISS/YAGNI**: implement when you need it, never when you predict you
   will. No unprompted abstraction; stdlib before custom; a new dependency
   demands justification in the LOG.
4. **SOLID translated**: one reason to change (S) · new variants without
   touching consumers (O) · honored contracts (L) · small interfaces (I) ·
   dependencies passed in, not global (D).
5. **Mandatory doc**: every unit has a context `.md` linked to
   ADRs. Unit without doc or doc without unit = commit blocked.
6. **Bug = root cause**: grep every caller before touching. Symptom
   patching leaves the sibling broken.

## 3. Skills — taxonomy and visibility

| Layer | Who knows | Content |
| agent-skills (9, fixed) | always loaded | clarify, decompose, model-domain, catalog, implement, verify-objective, contain, capture-human, audit |
| implements-skills | **only `implement`**, via IMPLEMENTS-CATALOG.md | varies per project: dialect, tests, patterns |
| platform-skills | only for deploy tasks | vercel, cloudflare, … |

**Visibility law**: `implement` is the ONLY gateway to implements-skills.
No other skill — not even this file — knows a single one. The selection of
each execution is recorded in the LOG with rationale (absence too:
"none applicable because…").

**Classification criterion**: survives an empty repo → agent-skill.
Needs code to exist → implements-skill.

## 4. Pipeline and classification

`contain` classifies BEFORE executing:

| Class | Criterion | Path |
|---|---|---|
| trivial | diff < 10 lines, no contract change | minimal diff + 1 LOG line. Done. |
| medium | one unit or one micro | light clarify → implement → verify-objective |
| large | changes understanding, several units, domain decision | clarify → decompose → (model-domain) → implement → verify-objective |

Every medium/large stage ends with a context-now record (§6). No exceptions.
Bureaucracy on a trivial task is the shortest path to hating the process.

## 5. Verification — QA-first

The **objective test** is the delivery gate: how would a QA test it? Behavior,
integration, acceptance — with executable evidence (command + output in the LOG).
The form varies per project (it lives in implements-skills); the requirement is fixed.

- Unit tests follow TDD strictly, but are internal hygiene.
- Green unit tests + broken objective = **FAILED**.
- "I'll validate later" is where objectives die. There is no later.

## 6. context-now protocol

```markdown

.context/NOW.md        snapshot, rewritten at every transition, 100-line ceiling
.context/log/NNN-*.md  append-only; the past is never rewritten

```

**Always written** (via file tools — never pollutes the window), at the end of
every medium/large skill. **Read on demand**, with 3 triggers: (1) cold start
with an in-progress NOW; (2) post-compaction or lost confidence in state;
(3) audit or route choice, via the objectives catalog.

**NOW line rule**: a line enters if, and only if, it changes a future decision.
**Ceiling as diagnosis** (ADR-0009): over 100 lines → decomposition
failed. Go back one step; don't write a bigger NOW.

## 7. Commits

- A commit that touches a unit touches (or declares unchanged) its doc and
  the linked ADRs — in the same commit (ADR-0004).
- The agent declares the files it will touch in `.context/touched`;
  `hooks/pre-commit` compares against staged.
- Divergence (file out of flow) requires `.context/pending-human.md`
  filled: `because` + `concept` (ADR-0007). Without it, commit blocked.
  Gate fast path: lockfiles and `.md` files without unit frontmatter →
  `because` alone suffices. `capture-human` expands the pending into a
  full LOG entry in the next session.

```markdown

This repo's units, ADRs and skills are indexed in CATALOG.md and ADR-CATALOG.md. Consult them; do not duplicate them here.

```
