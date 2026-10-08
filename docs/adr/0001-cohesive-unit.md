---
id: 0001
status: accepted
supersedes: —
units: [skills/agents-skills/*/SKILL.md, AGENTS.md]
---
# Single responsibility per cohesive unit, not per function per file

## context

The original proposal required "one function per file". In Go and Rust this is
anti-idiomatic and causes navigation explosion. The real goal was
traceability and fast location, not file counting.

## alternatives

- Literal one function/file: rejected — anti-idiomatic in Go/Rust, worsens navigation.
- No structural rule: rejected — agents waste time rereading code to find concepts.

## consequences

We gain: language-agnostic traceability, concise docs, focused tests.
We give up: simple mechanical enforcement — "cohesive" requires judgment in review.
The judgment has a ruler: file name = name of the single concept; 50–150 lines.
