---
unit: review-fixes
date: 2026-10-14
agent: ai-zcode
---
# LOG 024 — LOG 023 findings fixed and dev-ai integrated into dev-ai-zcode

Fixes applied in the merge of origin/dev-ai (7f0e086) into dev-ai-zcode
(936cac4), resolving all six LOG 023 findings:

1. ADR goal/ decision renumbered 0012→0015 (collision with the integrated
   agent-branch-identity ADR-0012). Non-LOG references updated; LOG stays
   append-only, disambiguated by a note in ADR-CATALOG.md.
2. hooks/pre-commit: protected-branch gate moved BEFORE the empty-index
   exit; `git commit --allow-empty` on a protected branch is now blocked
   (reviewer's bypass repro now exits 1).
3. installer/test-install.sh: merge test now builds a branch with its own
   commit and asserts a real two-parent merge on protected main; new assert
   for the blocked empty commit.
4. AGENTS.md §1: resume rule keeps sessions on this agent's own
   branch/worktree — no checkout away from valid work (LOG 007 lesson).
5. AGENTS.md §8: feature/<slug> removed from the agent topology — agents
   commit only on the exact mapped dev-ai-<agent> branch (ADR-0012
   contract); mapped identities never ride feature branches.
6. Claim protocol completed (AGENTS.md §8 + ADR-0014): a claim counts only
   once pushed to origin; before implementing the agent re-checks
   origin/dev-ai* and open PRs; collision resolves by earlier published
   claim commit; the loser marks status: abandoned and stops. goal/004
   micros now dogfood owner: frontmatter.

verification: `bash installer/test-install.sh` → ALL GREEN (0 failures),
now 34 asserts including "protected branch blocks empty commit without
why" and "real merge commit (two parents) works on protected branch".
Note: running the suite under GIT_CONFIG_* identity overrides breaks the
agent-lock positive cases (env overrides target config) — run it in a
clean environment.

next: push dev-ai-zcode, PR to dev-ai, independent re-review (LOG 023
closure condition).
