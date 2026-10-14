---
id: 004
status: in-progress
owner: zcode
created: 2026-10-08
source: BACKLOGS/002-multiagent-flow.md remainder (user request)
---
# multiagent-flow — the remainder of BACKLOGS/002

## Objective
Complete the multiagent flow: deterministic branch gate (opt-in via
.context/protected-branches), the claim mechanism (owner: in micro
frontmatter — this file dogfoods it), and the AGENTS.md amendment
documenting the flow. Topology itself already lives since LOG 008.

## Success metric
A direct (non-merge) commit by an agent on a protected branch is blocked
by the hook with a clear message; the human path (because:) passes;
merges still work; target projects without the file are unaffected.

## Map
| # | micro | depends on | status | objective test (1 line) |
|---|-------|------------|--------|-------------------------|
| 1 | 001-adr-0014.md | — | done | ADR-0014 file + ADR-CATALOG line; openings resolved |
| 2 | 002-branch-gate.md | 1 | done | hook blocks protected direct commit; because: passes; suite 24/24 |
| 3 | 003-agents-amendment.md | 1 | done | AGENTS.md §1.4 + §8 carry the flow |
| 4 | 004-verify-close.md | 2,3 | done | live block on dev-ai evidenced in LOG 019 |
