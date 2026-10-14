---
status: done
---
# 004 — Verify the branch lock and isolate Codex identity

objective: prove the mapping behavior through the installer objective suite
and configure this Codex worktree without changing global or shared identity.

criteria:
- [x] Correct Codex and ZCode identities pass only on their assigned branches.
- [x] Wrong branch, mismatched name/email, unknown identity on a reserved branch, and detached HEAD are blocked.
- [x] A merge commit on a reserved agent branch invokes the guard.
- [x] Codex's effective worktree config is ai-codex <dev-ai-codex@nanerr.local> with agent.id ai-codex on dev-ai-codex.
- [x] Global Git identity is unchanged.

dependencies: goal/005-agent-branch-lock/003-hook-install.md
units: installer/test-install.sh, installer/test-install.md, local Git worktree config
inherited assumptions: hooks may be bypassed deliberately by disabling them; this rule prevents accidental or ordinary workflow drift.
objective test: installer/test-install.sh ends ALL GREEN; effective branch, name, email, and agent.id match the spec.
