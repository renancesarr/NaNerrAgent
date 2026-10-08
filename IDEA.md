# IDEA.md

## The problem

Every developer using coding agents (Codex, OpenCode, ZCode) faces the same
five problems, in every language:

1. **The agent doesn't know what already exists** — it burns tokens re-reading
   code to discover what it could have found in an index.
2. **The ambiguous prompt becomes wrong code** — the rework of misinterpreting
   is more expensive than a 30-second question beforehand.
3. **Documentation rots** — outdated documentation is worse than no
   documentation, because the agent trusts it.
4. **Context dies with the session** — compaction, crash, new machine:
   everything the agent "knew" evaporated, and quality drops without anyone
   knowing where.
5. **Human editing is a black hole** — the human changes code outside the flow,
   the reason for the change is never captured, and it becomes archaeology at
   the next bug.

None of the existing frameworks solves all five. Most solve one or two
and add their own (bureaucracy, 293 skills nobody navigates, mandatory TDD
for a typo).

## The idea in one sentence

**A small, fixed set of agent-skills that makes the agent work with state
outside the conversation: catalogs index what exists, ADRs record why it
exists, NOW/LOG record where execution stands — and every change, including
the human one, is forced to keep that state true.**

## What it is

- A set of **9 core agent-skills, fixed, language-agnostic**
  (Python, TypeScript, Java, Go, Zig, Rust), that will always be present. And only the current agent-skill should be loaded.
- A **transversal protocol (context-now)** that cuts across all skills:
  always writes, reads on demand.
- An **implementation router**: the project-specific skills
  (implements-skills) are invisible by default; only the `implement`
  skill knows them, via catalog, and loads only the 1–3 useful for the
  current task.
- A **deterministic pre-commit gate** that turns every human edit
  into captured knowledge.
- Designed for **Codex, OpenCode and ZCode** — three similar CLIs, one system.

## What it is NOT

- It is not a market framework, not a plugin for 15 harnesses.
- It is not TDD-first: the test of the **objective** is the gate (QA style);
  unit tests follow strict TDD but are internal hygiene.
- It is not formal DDD: ubiquitous language and ADRs yes; bounded contexts and aggregates no.
- It is not "one function per file": it is **one cohesive unit per file** — one
  concept, one reason to change (anti-idiomatic would be the opposite in Go/Rust).
- It is not ECC: no hundreds of always-available skills. Small core +
  declared periphery. If it's not in the setup, the agent doesn't use it.

## The nine mechanisms

| # | Mechanism | What it does |
| 1 | 3-layer taxonomy | agent (fixed) / implements (per project, invisible)|
| 2 | Code catalog | 1-line index per unit + context doc beside each file |
| 3 | ADR catalog | decisions with bidirectional links to units; a change forces synchronization |
| 4 | Prompt clarification | ambiguities detected → 3 options (conservative/balanced/comprehensive) |
| 5 | Decomposition | checkpoint → macro → micro, each micro with spec and objective test |
| 6 | QA-first verification | delivery gate = objective behavior with executable evidence |
| 7 | context-now | NOW (snapshot ≤100 lines) + LOG (append-only); resumption without LLM cache |
| 8 | Human gate | deterministic pre-commit requires a reason for out-of-flow edits |
| 9 | Containment + fast path | trivial/medium/large classified BEFORE; trivial doesn't pay the pipeline |

## Genealogy — honest composition

| Source | We take | We adjust | We reject |
| Matt Pocock | grilling, glossary, ADRs, to-spec/to-tickets | ADRs grouped into a catalog with mandatory linkage | excessive granularity (40 ADRs = non-decisions) |
| Superpowers | understanding pipeline, decomposition, execution per task | gate becomes QA-first, not TDD-first | strict TDD as the center |
| Agent Skills (Addy) | verification discipline, anti-rationalization tables, mandatory evidence | applied to the objective, not only to unit tests | web/frontend bias |
| Ponytail | containment, fast path, reuse ladder (YAGNI/stdlib/1 line) | with our laws inside | "fewest files possible" against cohesive units |
| ECC | select organizational points | — | the ECC way: everything always available = lost agent |
| OpenDesign | — | — | it's a design workspace, not a methodology |

## What is genuinely new here

1. **The catalog as the central context index** — the agent discovers what
   exists by reading an index, not the code. No famous framework has this as
   a central piece.
2. **The asymmetry of context-now** — always writes (costly once, doesn't
   pollute the window), reads on 3 surgical triggers (cold start,
   post-compaction, audit). It's a write-ahead log applied to agents.
3. **The human gate** — manual editing is neither tolerated nor detected late:
   it is converted into knowledge (reason + concept + how) at the only moment
   when the memory of the reason exists: before the commit.

## Guiding principles

- **Cohesive unit**: if you can't name the file after its single
  concept, it does too much. 50–150 lines as a guide.
- **Radical DRY**: each piece of knowledge has ONE authoritative representation;
  the catalog points, never duplicates.
- **KISS/YAGNI**: implement when you need it, never when you foresee you'll
  need it. Bureaucracy proportional to the problem.
- **SOLID translated** to non-OO languages: one reason to change (S),
  variants without touching consumers (O), honored contracts (L), small
  interfaces (I), dependencies passed in (D).
- **The NOW ceiling is a diagnostic**: it exceeded 100 lines → the decomposition
  failed, not the documentation. Step back one stage.
- **Evidence > assertion**: "seems right" is never a criterion; command + output is.

## Target environment

- **CLIs**: Codex, OpenCode, ZCode.
- **Languages**: Python, TypeScript, Java, Go, Zig, Rust — what varies by
  language (layout, native doc, tests) lives in implements-skills declared
  in the project setup; what is universal lives in the core.
- **Skill classification criterion**: survives an empty repo →
  agent-skill. Needs code to exist → implements-skill.

## How to know it works

Three metrics, measured before vs. after, in real use:

1. Time until the agent **finds** existing code/decision.
2. Rate of **outdated** documentation at the end of each week.
3. Rework from **wrong understanding** (objective delivered ≠ requested).

And a free instrument: when quality drops, `audit` reads the LOG in
sequence and points to the exact transition where execution degraded — with
evidence, not guesswork.

## Current state

- Complete design, agreed in 6 rounds of clarification: ADRs 0001–0010.
- Bootstrap artifacts written: AGENTS.md, 9 skills, catalogs, hook, NOW, LOG.
- **Zero hours of real use.** The difference between this project and the ones
  that succeeded is not in the ideas — it's in the production scars, which
  don't exist yet. The LOG will generate them.

## Next step

Install on the 3 CLIs and execute the first real task in a real
repository. From then on, the system validates (or corrects) itself through
its own LOG.
```

---

Delivered the IDEA.md — contained, every section changes the decision of whoever reads it, without repeating what the ADR-CATALOG already indexes.

**The queue, in the order I propose:**

1. ✅ IDEA.md *(this one)*
2. AGENTS.md *(the laws — already written in the previous round, I'll review and resend)*
3. The 9 skills, one per message
4. Catalogs (CATALOG / ADR-CATALOG / IMPLEMENTS-CATALOG) + example ADR
5. `hooks/pre-commit` + `.context/` (NOW, LOG, pending-human, touched)

Do I confirm AGENTS.md as next?
