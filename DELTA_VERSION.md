Dogfooding. What this implies, in three points, before the artifacts:

1. **This entire conversation was the `clarify` + `model` step** — so it becomes the first LOG entry and the decisions we closed become ADRs 0001 through 0010 of the meta-repo
2. **Each skill is a cohesive unit** — so the repo's own CATALOG.md catalogs the 9 skills that compose it
3. **The first real execution of NOW.md already exists** — reflecting exactly where we are: bootstrap artifacts created, next step = installation and first real task

And applying `contain` to this very response: each skill stays between 70–90 lines, the context-now protocol is defined **once** in AGENTS.md and merely referenced in the skills (DRY), and the ADRs live in a catalog + 1 complete example.

## Repo Structure

```
.
├── AGENTS.md                    # the laws. always loaded. ~130 lines
├── CATALOG.md                   # catalog of units (the 9 skills)
├── ADR-CATALOG.md               # index of decisions
├── IMPLEMENTS-CATALOG.md        # empty at bootstrap — the meta-repo has no dialect yet
├── docs/adr/
│   ├── 0001-cohesive-unit.md    # complete example; 0002–0010 follow the template
│   └── ...
├── skills/
│   ├── clarify/SKILL.md
│   ├── decompose/SKILL.md
│   ├── model-domain/SKILL.md
│   ├── catalog/SKILL.md
│   ├── implement/SKILL.md
│   ├── verify-objective/SKILL.md
│   ├── contain/SKILL.md
│   ├── capture-human/SKILL.md
│   └── audit/SKILL.md
├── hooks/
│   └── pre-commit               # deterministic gate
└── .context/
    ├── NOW.md                   # current snapshot
    ├── touched                  # files declared by the agent (the hook reads it)
    ├── pending-human.md         # template for the human rationale
    └── log/
        └── 001-clarify.md       # this conversation
```

---

## AGENTS.md

````markdown
# AGENTS.md — Development Agent with Persistent Context

You work with state outside the conversation: catalogs index what exists,
ADRs record why it exists, NOW/LOG record where execution stands.
Nothing important lives only in your session memory.

## 1. Laws

1. **Cohesive unit**: one file = one concept = one reason to change.
   If you cannot name the file after its single concept, it does too much. Guide: 50–150 lines.
2. **DRY**: every piece of knowledge has ONE authoritative representation. The catalog points; it does not duplicate.
3. **KISS / YAGNI**: implement when you need it, never when you foresee needing it. No unrequested abstraction, no avoidable new dependency, stdlib before custom.
4. **SOLID translated**: one reason to change (S) · new variants without touching consumers (O) · honored contracts (L) · small interfaces (I) · dependencies passed in, not globals (D).
5. **Mandatory documentation**: every unit has its context `.md`. Unit without doc or doc without unit = commit blocked.
6. **Bug = root cause**: grep every caller before touching. Patching the symptom leaves the sibling broken.

## 2. Skills — taxonomy and visibility

| Layer | Who knows it | Example |
|---|---|---|
| `agent-skills/` (9) | always loaded | clarify, decompose, model-domain, catalog, implement, verify-objective, contain, capture-human, audit |
| `implements-skills/` | **only `implement`**, via IMPLEMENTS-CATALOG.md | rust-testing, go-api-patterns |
| `platform-skills/` | only when the task is deployment | vercel, cloudflare |

**Law of visibility**: `implement` is the ONLY gateway to implements-skills.
AGENTS.md knows none of them. Selection is recorded in the LOG with justification.

**Classification criterion**: survives an empty repo → agent-skill.
Needs code to exist → implements-skill.

## 3. Pipeline with fast path

Classify BEFORE executing (`contain`):

| Class | Criterion | Path |
|---|---|---|
| trivial | diff < 10 lines, no contract change | minimal diff, 1 LOG entry, done |
| medium | one unit or one task | light clarify → task → verification |
| large | changes understanding or multiple units | full pipeline |

Full pipeline: `clarify` → `decompose` → (`model-domain` if there is a decision) → `implement` → `verify-objective`. Every step ends with a context-now record (§5). No exceptions.

## 4. Verification — QA-first

The **objective test** is the gate: how would a QA test it? Behavior, integration, acceptance. The form varies per project (declared in implements-skills); the requirement is fixed.

Unit tests follow TDD to the letter, but are internal hygiene.
A PR with green unit tests and a broken objective = REJECTED.
Delivery requires executable evidence, never assertion.

## 5. context-now protocol

```
.context/
├── NOW.md      # snapshot, rewritten at every transition, cap of 100 lines
└── log/NNN-*.md  # append-only, never rewrites the past
```

**Writing is mandatory and always** (via the file tool — don't pollute the window).
**Reading is on demand, with 3 triggers**: (1) cold start with NOW in-progress;
(2) post-compaction or when confidence in the state drops; (3) audit/routing, via the objectives catalog.

**Line rule**: enters the NOW if, and only if, it changes a future decision.

**The NOW cap = diagnostic instrument**: over 100 lines → decomposition failed, step back one stage. Don't write a bigger NOW.

**Resuming**: read the NOW → latest LOG entry → check against `git status` and real artifacts. Divergence → re-validate the step, never resume blindly.

## 6. Commits and human edits

- A commit that touches a unit also touches (or declares unchanged) its doc and the linked ADRs, in the same commit.
- The `hooks/pre-commit` hook compares staged vs `.context/touched`. Divergence requires a filled `.context/pending-human.md` (because + concept). Without it, the commit is blocked.
- In the next session, `capture-human` expands the pending file into a full LOG entry.

## 7. Fast path for the trivial

Typo, color, local rename, lockfile: minimal diff, one LOG line, no ceremony.
Bureaucracy in a trivial task is the fastest way to hate the process.
````

---

## The 9 Skills

### skills/clarify/SKILL.md

````markdown
---
name: clarify
description: >
  Analyzes the prompt before any execution. Detects ambiguities and suggests
  3 adjustment options per ambiguity. Use when receiving any new task
  classified as medium or large. Do not use for trivia (see contain).
---

# clarify

## Objective
Ensure the problem is understood before wrong code exists.

## Process
1. Read the prompt. Extract: main objective, explicit requirements, implicit requirements.
2. Detect ambiguities: vague terms, undefined scope, missing success metric, conflicting requirements.
3. For EACH ambiguity, generate 3 options:
   - **conservative** — narrowest interpretation
   - **balanced** — intermediate
   - **comprehensive** — broadest
4. Present identified objective + ambiguities + options + your recommendation (one per ambiguity).
5. Wait for the choice. Rewrite the prompt with the choices incorporated.
6. Done: record the transition (AGENTS.md §5). Specific fields in the LOG:
   `original-prompt`, `clarified-prompt`, `ambiguities + chosen options`.

## Anti-rationalization
| Excuse | Response |
|---|---|
| "It's clear enough" | Can you formulate 2 interpretations? Then it isn't. |
| "I'll ask mid-way if needed" | Doubt mid-way costs rework; doubt now costs one message. |
| "The user will find it annoying" | 3 numbered options are answered with one digit. |

## Verification
Rewritten prompt validated by the user (explicit response, not silence).
Zero listable ambiguities remaining.
````

### skills/decompose/SKILL.md

````markdown
---
name: decompose
description: >
  Divides the clarified objective into checkpoint → macro-objective → micro-objective.
  Each micro becomes a task with a specification and a verifiable criterion.
  Use after clarify on medium/large tasks.
---

# decompose

## Objective
No task bigger than one session. No NOW that bursts the cap.

## Structure
- **checkpoint** — macro deliverable (weeks)
- **macro-objective** — component of the checkpoint (1–2 weeks)
- **micro-objective** — atomic task (hours, one session, one step of the NOW)

## Process
1. From the clarified prompt, list the checkpoints.
2. Break each checkpoint into macro-objectives.
3. Break each macro into micros. For each micro, write the spec:

```markdown
# [micro name]
objective: [1–2 lines]
criteria: [ ] ... [ ] ...        ← independently verifiable
dependencies: [previous micros or —]
units: [files to create/modify, if known]
objective test: [how a QA would validate THIS micro]
```

4. Prioritize: value first, risk early, dependencies respected.
5. Done: record the transition. The LOG receives: `checkpoints`, `macros`, `micro specs` (or a pointer to where they were saved). The NOW receives the first micro as the "immediate next step".

## Anti-rationalization
| Excuse | Response |
|---|---|
| "It's simple, I'll go straight in" | Simple doesn't need decomposition — reclassify as trivial via `contain`. |
| "I'll decompose as I go" | Every boundary moved mid-way costs rework on everything that has already touched it. |

## Verification
Each micro has a verifiable criterion without depending on another micro.
The count of micros × estimated size does not burst the NOW cap when described.
````

### skills/model-domain/SKILL.md

````markdown
---
name: model-domain
description: >
  Maintains the glossary (ubiquitous language) and the project's ADRs.
  An ADR = a decision with a lasting trade-off, nothing less.
  Use when a task changes a domain decision or introduces a new term.
---

# model-domain

## Objective
A term means exactly one thing. A decision with a trade-off has an address.

## Granularity rule (the most important in this skill)
- **ADR**: domain decision with a lasting trade-off (a choice among alternatives with consequence).
- **Code comment / line in the unit's doc**: technical micro-decision.
- If you have 40 ADRs in a small system, someone is documenting non-decisions.

## Process — glossary
1. New term or inconsistently used term? One entry in GLOSSARY.md:
   `**term** — one-line definition.`
2. Term not used anywhere in code/docs? Mark it as orphaned, propose removal.

## Process — ADR
1. Detected a decision with a trade-off? Create `docs/adr/NNN-slug.md`:
```markdown
---
id: NNN
status: accepted
supersedes: —
units: [paths of the units that uphold it]
---
# [decision in one sentence]
## context
[what pressure motivated it]
## alternatives
[those considered, with the con]
## consequences
[what we gain, what we give up]
```
2. Add the line to ADR-CATALOG.md.
3. Bidirectional link: the ADR lists `units`; each unit lists `decisions` in the frontmatter of its `.md` (`catalog` handles the other side).
4. Done: record the transition. LOG: `ADR created/amended + why`.

## DDD-lite — where to stop
Yes: ubiquitous language, traceable decisions, boundaries by domain.
No: formal bounded contexts, aggregates, ceremony. CRUD is CRUD.

## Anti-rationalization
| Excuse | Response |
|---|---|
| "I'll decide and document later" | Later never comes; the decision becomes archaeology in the next bug. |
| "It's a technical detail, not an ADR" | Then it's a code comment. Confirm the granularity, don't skip the record. |

## Verification
An ADR without the `alternatives` field is invalid.
A glossary term used with 2 meanings in the code = this skill failed.
````

### skills/catalog/SKILL.md

````markdown
---
name: catalog
description: >
  Maintains CATALOG.md (index of units) and each unit's context .md,
  with a bidirectional link to ADRs. Use when creating/changing any unit.
---

# catalog

## Objective
The agent discovers what exists by reading an index, not the entire codebase.

## Process
1. New (or changed) unit → the `.md` next to it:

```markdown
---
unit: path/file.ext
decisions: [ADR-NNN, ...]
last-sync: <commit hash>
---
# [name]
responsibility: [1–2 sentences]
interface: [what is public, minimal signature]
dependencies: [units and ADRs]
example: [minimal real usage]
notes: [what the next reader needs to know and cannot see from the signature]
```

2. One line in CATALOG.md: `| path | responsibility in 1 line |`
3. ADR link: frontmatter `decisions` ↔ the ADR's `units` field.
4. Changed the unit without changing the contract? Update `last-sync`, declare "contract unchanged".
5. Done: record the transition. LOG: `units touched + corresponding docs`.

## Sync rules
- A commit that touches `X` touches `X.md` (or declares the contract unchanged). No exceptions.
- Unit without doc = commit blocked (the same gate as pre-commit).
- Orphaned ADR (no units) = warning in the next audit.

## Anti-rationalization
| Excuse | Response |
|---|---|
| "Small file, it explains itself" | The catalog is for the agent who has NEVER opened this file. |
| "I'll update the doc at the end" | The end of what? Each commit is a valid state or it isn't. |

## Verification
CATALOG.md without a line for the created unit = skill not executed.
Frontmatter without decisions when the domain has applicable ADRs = broken link.
````

### skills/implement/SKILL.md

````markdown
---
name: implement
description: >
  Executes a micro-objective. ONLY gateway to implements-skills: consults
  IMPLEMENTS-CATALOG.md, selects 1–3 for the task, loads only what is needed.
  Use for every code execution.
---

# implement

## Objective
Code with the right skill for the right dialect, paying only for what this task uses.

## Process
1. Take the micro from the NOW. Check the spec (objective, criteria, units, objective test).
2. Read IMPLEMENTS-CATALOG.md. Select 1–3 skills whose `use when` matches the task.
   None matches? Proceed without — catalog the gap as a candidate.
3. Load ONLY the selected ones. Execute the micro following them.
4. Before the commit: declare the touched files in `.context/touched`
   (pre-commit compares against this — AGENTS.md §6).
5. Unit tests: TDD to the letter on logic units (the chosen implements skill defines the form).
6. Done: record the transition. LOG: `micro executed`, `implements selected + WHY`,
   `summarized diff`. NOW: next micro as the "immediate next step".

## Anti-rationalization
| Excuse | Response |
|---|---|
| "I'll load all the implements, it's safer" | That's ECC mode: everything available always = agent lost always. |
| "I don't know which one serves, I'll read two entirely" | The catalog has `use when` for exactly this. If it doesn't, the catalog is bad — fix it. |

## Verification
Selection of implements recorded in the LOG with justification (absence is also a record: "none applicable because...").
Files in the commit ⊆ files declared in `.context/touched`.
````

### skills/verify-objective/SKILL.md

````markdown
---
name: verify-objective
description: >
  Validates the objective/micro the way a QA would test it: behavior, integration,
  acceptance. This is the delivery GATE — not unit TDD, which is internal hygiene.
  Use when closing every micro and every objective.
---

# verify-objective

## Objective
Prove that what was asked for happened. With executable evidence.

## Process
1. Re-read the micro's spec: the `objective test` field says HOW to validate.
   Empty field? The spec is incomplete — go back to `decompose`, don't invent the test now.
2. Execute the objective test. Record: command, output, result.
3. Rejection checklist (any one fails it):
   - [ ] objective tested as behavior, not as "the code looks right"
   - [ ] error paths exercised (invalid input, limit, empty)
   - [ ] integration between the micro's units exercised, not just isolated units
   - [ ] evidence is reproducible (command + output recorded in the LOG)
4. Failed? Don't deliver. Record the failure in the LOG, fix it, re-run. Loop until green.
5. Passed? Done: record the transition. LOG: `test executed + evidence`.
   NOW: micro marked complete.

## Anti-rationalization
| Excuse | Response |
|---|---|
| "All unit tests green" | Green units + broken objective = REJECTED. Hierarchy in AGENTS.md §4. |
| "Testing the objective is expensive" | More expensive is discovering it from the user. |
| "I'll validate manually later" | "Later" is where objectives go to die. |

## Verification
LOG entry with command + real output. Without it, the micro is NOT complete, regardless of what the rest says.
````

### skills/contain/SKILL.md

````markdown
---
name: contain
description: >
  Classifies the task (trivial/medium/large) BEFORE executing and applies the fast
  path to the trivial. Contains over-engineering throughout execution.
  First skill to run on any task.
---

# contain

## Objective
Bureaucracy proportional to the problem. Minimal code that works.

## Classification (before everything)
| Class | Criterion | Path |
|---|---|---|
| trivial | diff < 10 lines, no contract change | minimal diff, 1 LOG line, no pipeline |
| medium | one unit or one micro | light clarify → implement → verify |
| large | changes understanding, multiple units, a domain decision | full pipeline |

## Containment ladder (before writing code, in order)
1. Does it need to exist? (YAGNI — speculative need doesn't exist)
2. Does it already exist in the catalog? Reuse.
3. Does stdlib/the platform solve it? Use it.
4. Does an already-installed dependency solve it? Use it. New dependency = justification in the LOG.
5. Does one line solve it? One line.
6. Only then: minimal code that works.

## Laws during execution
- No unrequested abstraction; an interface with 1 implementation doesn't exist.
- Deletion > addition. Boring > clever (clever is what someone has to decipher at 3am).
- Bug = root cause: grep every caller before touching.
- Deliberate corner cut with a known ceiling? Comment it: `containment: [ceiling], migrate when [trigger]`.

## Never contain
Validation at a trust boundary, handling that prevents data loss,
security, basic accessibility, anything explicitly requested.

## Done: record the transition. LOG: `classification + rationale in 1 line`.

## Anti-rationalization
| Excuse | Response |
|---|---|
| "I'll make it complete, it's more robust" | Robustness without a requirement is weight with a fancy name. |
| "I'll refactor later" | Later is debt; now is minimal diff. |

## Verification
Classification recorded in the LOG BEFORE execution (not reconstructed afterwards).
````

### skills/capture-human/SKILL.md

````markdown
---
name: capture-human
description: >
  Processes human edits outside the flow: reads the because and the concept from
  .context/pending-human.md, analyzes the diff, generates the "how it was done",
  records it in the LOG as knowledge and reconciles the NOW.
  Runs at the start of every session that finds a filled pending file.
---

# capture-human

## Objective
A human edit enters the flow as captured knowledge, not as a black hole.

## Process
1. Cold start: does `.context/pending-human.md` exist with `because:` and `concept:` filled?
   Doesn't exist/not filled → nothing to do (the hook's gate enforces the requirement).
2. Read the because and the concept. Get the real diff of the corresponding commit.
3. Generate the "how it was done": what the edit does technically, connected to the because.
4. Write a LOG entry:
```markdown
# NNN — capture-human (origin: manual edit)
when: [commit timestamp]
because: [what the human wrote, verbatim]
concept: [the idea behind it, verbatim]
how: [generated by the AI from the diff, connecting the technique to the because]
affected units: [from the diff]
NOW impact: [none | adjustment made]
```
5. Reconcile: does the edit invalidate a domain decision? → `model-domain` (amend or new ADR).
   Invalidates unit docs? → `catalog`. Changes the next step? → rewrite the NOW.
6. Clear pending-human.md and `.context/touched` (state consumed).
7. Done: this skill IS a transition — the entry above is the record.

## Anti-rationalization
| Excuse | Response |
|---|---|
| "Small diff, no need to capture" | The small diff with the wrong because is the expensive bug. The cost is reading 2 lines. |
| "I'll just sync the NOW" | Without the because, the edit becomes a permanent mystery — archaeology in the next audit. |

## Verification
LOG entry with the 3 fields (because verbatim, concept verbatim, how generated).
NOW reconciled or declared without impact.
````

### skills/audit/SKILL.md

````markdown
---
name: audit
description: >
  On-demand diagnosis when quality drops: reads the LOG in sequence,
  finds the transition where execution degraded, reports with evidence.
  Also sweeps units without docs, orphaned ADRs, orphaned terms.
  Invoked explicitly — never automatic.
---

# audit

## Objective
Answer "where did the process fail" with a LOG line in hand, not with a guess.

## Process
1. Read the objective's LOG in order. For each transition, check:
   - was the declared input what the skill actually received (against artifacts)?
   - was the declared output produced (against git/artifacts)?
   - are mandatory fields present (implements+why, test evidence, classification BEFORE)?
2. Structural sweeps:
   - units without `.md` or with `last-sync` behind the commit
   - orphaned ADRs (no units) and units with `decisions` pointing to a nonexistent ADR
   - GLOSSARY terms with no usage; usage of terms outside the glossary
   - NOW above the cap (→ decomposition failed)
3. Report, per finding: **severity · evidence (file+line/LOG entry) · probable cause · minimal fix**.
4. Don't fix in the same breath (unless trivial): audit is diagnosis.
5. Done: record the transition. LOG: `findings + severities`. The report becomes a file in `docs/audits/`.

## Guiding question
"What did skill N receive vs. what it produced — at which transition did the divergence begin?"
The first divergence is the location of the failure; everything after is cascade.

## Verification
Every finding cites a specific LOG entry or file+line.
A finding without citable evidence isn't a finding, it's an opinion.
````

---

## Bootstrap Artifacts

### ADR-CATALOG.md

```markdown
# ADR-CATALOG

| ID | Status | Decision (1 line) | Units |
|----|--------|-------------------|-------|
| 0001 | accepted | Single responsibility per cohesive unit, not per function/file | all skills |
| 0002 | accepted | 3-layer taxonomy; implement is the only gateway to implements | implement, AGENTS.md |
| 0003 | accepted | Catalog + doc per unit as the agent's context index | catalog, CATALOG.md |
| 0004 | accepted | ADRs with bidirectional link and mandatory update in the same commit | model-domain, catalog |
| 0005 | accepted | QA-first: the objective test is the gate; unit TDD is hygiene | verify-objective |
| 0006 | accepted | context-now: NOW+LOG; always write, read on 3 triggers | protocol, all |
| 0007 | accepted | Deterministic human gate in pre-commit + deferred enrichment | capture-human, hooks/pre-commit |
| 0008 | accepted | Mandatory fast path for the trivial | contain |
| 0009 | accepted | The NOW cap as a decomposition diagnostic | protocol, decompose |
| 0010 | accepted | DDD-lite: ubiquitous language yes, formal ceremony no | model-domain |
```

### docs/adr/0001-cohesive-unit.md (the others follow this template)

```markdown
---
id: 0001
status: accepted
supersedes: —
units: [skills/*/SKILL.md, AGENTS.md]
---
# Single responsibility per cohesive unit, not per function per file

## context
The original proposal required "one function per file". In Go and Rust this is
unidiomatic and causes navigation explosion. The real goal was
traceability and fast location, not file counting.

## alternatives
- Literal one function/file: rejected — unidiomatic in Go/Rust, worsens navigation.
- No structural rule: rejected — agents waste time rereading code to find concepts.

## consequences
We gain: language-agnostic traceability, concise docs, focused tests.
We give up: simple mechanical enforcement — "cohesive" requires judgment in review.
The judgment has a ruler: file name = name of its single concept; 50–150 lines.
```

### CATALOG.md

```markdown
# CATALOG — units

| Unit | Responsibility |
|---|---|
| AGENTS.md | laws, skill taxonomy, pipeline, context-now protocol |
| skills/clarify | detects prompt ambiguities, 3 options, validates understanding |
| skills/decompose | breaks objective into checkpoint→macro→micro with verifiable spec |
| skills/model-domain | glossary + ADRs with correct granularity and linking |
| skills/catalog | index of units + context doc + bidirectional link |
| skills/implement | routes implements-skills and executes the micro |
| skills/verify-objective | QA-first gate with executable evidence |
| skills/contain | trivial/medium/large classification + containment + fast path |
| skills/capture-human | turns a human edit into knowledge in the LOG |
| skills/audit | degradation diagnosis with LOG evidence |
| hooks/pre-commit | deterministic gate: divergence requires a because |
```

### hooks/pre-commit

```bash
#!/usr/bin/env bash
# ADR-0007: deterministic gate. LLM enrichment is deferred (capture-human).
set -euo pipefail

TOUCHED=".context/touched"
PENDING=".context/pending-human.md"
STAGED=$(git diff --cached --name-only)

[ -z "$STAGED" ] && exit 0

if [ -f "$TOUCHED" ]; then
  DIVERGENT=$(comm -23 \
    <(echo "$STAGED" | sort) \
    <(sort -u "$TOUCHED"))
else
  DIVERGENT="$STAGED"
fi

if [ -n "$DIVERGENT" ]; then
  if [ -f "$PENDING" ] && grep -q '^because: .\+' "$PENDING"; then
    exit 0   # because present; capture-human expands it in the next session
  fi
  echo "✋ Outside the agent's flow:"
  echo "$DIVERGENT"
  echo ""
  echo "Fill in .context/pending-human.md:"
  echo "  because:  <why you changed it>"
  echo "  concept:  <the idea behind it>"
  exit 1
fi

exit 0
```

### .context/pending-human.md

```markdown
because: 
concept: 
```

### .context/NOW.md

```markdown
# NOW
objective: bootstrap of the agent meta-repo
step: implement
phase: artifacts created / installation pending
status: in-progress

## Current understanding
The repo self-hosts the model: 9 core skills, AGENTS.md as law,
ADRs 0001–0010 derived from 6 clarification rounds. Human gate in
pre-commit, context-now protocol crossing everything.

## Decisions of this execution
- Skill names in English (canonical names)
- Full ADRs: only 0001 as an example, the rest via the catalog (containment applied to the delivery itself)
- pre-commit v1 doesn't cover merges — accepted, documented

## Immediate next step
Install on the 3 CLIs (Codex, OpenCode, ZCode) and execute the first real task

## Blockers
—
```

### .context/log/001-clarify.md

```markdown
# 001 — clarify + model (the conversation that originated the system)
when: [date]
input: idea of a simplified agent based on ponytail + 5 skill repos
output: agreed complete model (ADRs 0001–0010)
how: 6 rounds; each round attacked the worst fragility of the previous one:
      cohesive unit → taxonomy+router → ADR catalog → QA-first →
      asymmetric context-now → deterministic human gate
artifacts: AGENTS.md, 9 skills, catalogs, hook, ADRs
implements used: — (they didn't exist yet; bootstrap)
next: implement → installation on the CLIs
```
