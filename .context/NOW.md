# NOW
objective: enforce the exact agent branch, Git name, and email mapping
stage: verified
step: commit the refinement with ai-codex identity, push dev-ai-codex, then check the PR to dev-ai
status: in-progress

## Current understanding
Codex is `ai-codex <dev-ai-codex@nanerr.local>` on `dev-ai-codex`;
ZCode is `ai-zcode <dev-ai-zcode@nanerr.local>` on `dev-ai-zcode`.
The Codex identity is isolated with `git config --worktree`; global Git config
and the ZCode worktree are untouched.

## Decisions that change the future
- `.context/agent-branches` is authoritative for agent ID, name, email, branch.
- Branch mismatch means stop and attach the correct dedicated worktree.
- Missing or ambiguous identity mapping means ask the user; never guess.
- Commit and merge hooks check the exact identity/branch; pre-commit also checks staged paths against `.context/touched`.
- Each agent uses a separate worktree so work can proceed in parallel.

## Verification
`installer/test-install.sh`: ALL GREEN, 33 assertions; covers exact Codex/ZCode
pairs and rejection of wrong ID, name, email, branch, unknown identity,
detached HEAD, and merge commit. `git diff --check` and `bash -n` passed.

## Immediate next step
Commit the verified refinement and push dev-ai-codex.

## Blockers
The earlier PR attempt for commit 4f560437 returned 403 from the GitHub
integration. Revisit PR creation after this refinement is pushed.
