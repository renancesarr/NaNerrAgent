---
id: 0012
status: accepted
supersedes: —
units: [AGENTS.md, hooks/check-agent-branch.sh, hooks/pre-commit, hooks/pre-merge-commit, .context/agent-branches, BACKLOGS/004-agent-identity-config.md]
---
# Each agent is bound to one work branch and Git identity

## context
Agents share a repository but need separate commit attribution and must not
work from another agent's branch. Shared repository-local Git config can
leak one agent's identity into a linked worktree.

## alternatives
- Instructions only in AGENTS: easy to read, but commits on the wrong branch
  are not mechanically blocked.
- Git identity in global or shared local config: simple, but overwrites or
  leaks identity between agents and worktrees.
- Per-worktree Git identity plus a tracked identity-to-branch map checked by
  pre-commit: isolates author metadata and blocks mismatched commits.

## decision
Use per-worktree Git configuration and a repository mapping that binds each
supported agent's Git name/email to exactly one branch. AGENTS requires a
branch check before work and configures identity only when that branch is correct. Codex is
codex-ai <codex-ai@nanerr.local> on dev-ai-codex. ZCode is
zcode-ai <zcode-ai@nanerr.local> on dev-ai-zcode. The mapping is only present
in this meta-repository; target installs without it retain their existing
hook behavior. PRs target dev-ai and require review by another agent or human.

## consequences
Agents must verify their branch and effective Git identity at session start.
The pre-commit and pre-merge-commit gates reject a known identity on another
branch and unknown identities on reserved agent branches. The installer does
not copy the meta-repository map into target projects. Local hooks protect the
normal workflow; hosting-side branch rules are needed to resist intentional bypass.
