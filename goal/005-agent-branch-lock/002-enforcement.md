---
status: done
---
# 002 — Authoritative agent map and guard

objective: add one tracked mapping and a reusable shell check that rejects
known identities on the wrong branch and unknown identities on reserved
branches.

criteria:
- [x] Map rows identify agent, Git name, Git email, and exact branch.
- [x] Codex maps to ai-codex <dev-ai-codex@nanerr.local> on dev-ai-codex.
- [x] ZCode maps to ai-zcode <dev-ai-zcode@nanerr.local> on dev-ai-zcode.
- [x] Matching identity passes; mismatch, unknown identity on reserved branch, unknown agent.id, and detached HEAD fail.
- [x] A repository without the map receives no agent-specific restriction.

dependencies: goal/005-agent-branch-lock/001-contract.md
units: .context/agent-branches, hooks/check-agent-branch.sh, hooks/check-agent-branch.md
inherited assumptions: the tracked map is authoritative; worktree-specific agent.id is optional but strengthens resolution when configured.
objective test: inspect the map and exercise the helper in isolated temporary Git repositories for each allowed/error case.
