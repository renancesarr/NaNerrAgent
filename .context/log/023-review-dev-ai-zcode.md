# 023 — Review dev-ai-zcode before integration

when: 2026-10-11
classification (contain): large — eight commits span agent policy, hooks, skills, ADRs, catalog, and goal state; merge is conditional on review.
implements: none applicable because this is a read-only review; no code changed.
scope: GitHub compare dev-ai...dev-ai-zcode reports 8 commits ahead, 1 behind; merge base 92879ccc29f5a2f6a55018c6e88c073b3452ae01. Review range: `git diff origin/dev-ai...origin/dev-ai-zcode`; commits: `git log origin/dev-ai..origin/dev-ai-zcode --oneline`.

## Standards findings
1. `CATALOG.md:9,13,15` is stale: IDEA is called the authoritative spec, installer tests are counted as 20 rather than 24, and decompose still says checkpoint→macro→micro despite ADR-0012/0013 and the skill change.
2. `AGENTS.md:111` requires agents to commit only on their own branch, but `hooks/pre-commit:19-28` only protects branches listed in `.context/protected-branches`; it does not verify agent-to-branch identity. This also conflicts with the current user identity contract.
3. `hooks/pre-commit` and `.context/protected-branches` lack required unit context `.md` docs and catalog entries (AGENTS.md §2.5).
4. `hooks/pre-commit:12` exits successfully when there are no staged files before checking protected branches. Objective repro: `git commit --allow-empty` on `main` without a why was allowed.

## Spec findings
1. Commit `936cac4` is authored as `zcode-ai <zcode-ai@nanerr.local>`, while current user policy requires `ai-zcode <dev-ai-zcode@nanerr.local>`.
2. `AGENTS.md:17-19` says to `git checkout` the agent branch if not already selected, which can switch another task's branch in a shared worktree; direct the agent to its own worktree instead.
3. `installer/test-install.sh:106-108` claims to test a merge but merges `HEAD~2`, an ancestor. Repro returned “Already up to date” and HEAD did not change; the assertion is a false positive.

## Objective verification
Command: exported the `origin/dev-ai-zcode` tree to a temporary directory, then ran `bash -n hooks/pre-commit installer/install.sh installer/test-install.sh && installer/test-install.sh`.
Result: `ALL GREEN (0 failures)`, 24 assertions. Limitation: the merge assertion is a no-op (finding 3). Empty-commit hook repro: allowed (finding 4).

## Decision
Do not merge to dev-ai yet. No files or refs on dev-ai-zcode were changed. Re-review after the findings are corrected on the owning branch.
