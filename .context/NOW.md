# NOW
objective: enforce the exact agent branch, Git name, and email mapping
stage: published
step: open PR from dev-ai-codex to dev-ai with an account that has pull-request write permission
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
Open the PR to dev-ai when the GitHub integration has write permission.

## Blockers
Commit 104e92292b8ccf1ca96febd26ddf856aea1835e1 was pushed to
origin/dev-ai-codex as ai-codex <dev-ai-codex@nanerr.local>.
No open PR exists for dev-ai-codex to dev-ai. Creation returned 403
Resource not accessible by integration.
