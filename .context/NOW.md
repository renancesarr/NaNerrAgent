# NOW
objective: enforce the agent branch and Git identity lock
stage: verified
step: commit the completed change on dev-ai-codex, then open a PR to dev-ai
status: in-progress

## Current understanding
The tested guard binds Codex to codex-ai <codex-ai@nanerr.local> on
dev-ai-codex and ZCode to dev-ai-zcode. This worktree's identity is isolated
with git config --worktree. The global identity is unchanged.

## Decisions that change the future
- The exact branch and identity mapping lives in .context/agent-branches.
- AGENTS checks branch first and configures identity only inside the correct worktree.
- Commit and merge hooks reject mismatches; target installs omit the mapping.
- The PR must be reviewed by a different agent or a human.

## Immediate next step
Commit this verified change with the Codex worktree identity and push dev-ai-codex.

## Blockers
PR creation must use an account with repository pull-request write access.
