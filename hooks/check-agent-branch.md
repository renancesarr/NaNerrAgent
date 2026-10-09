---
unit: hooks/check-agent-branch.sh
decisions: [ADR-0012]
last-sync: 2026-10-09
---
# Agent branch identity check
responsibility: compares the effective Git name/email and optional agent.id
with .context/agent-branches before commit hooks allow a commit.
interface: executable hook helper; exits 0 for allowed/unmapped contexts and
nonzero with an explanation for a mismatch.
dependencies: .context/agent-branches, git config, git branch.
example: Codex identity on dev-ai-codex passes; the same identity on any other
branch is rejected.
notes: the map is meta-repository-only. A target without the file has no
agent-specific restriction. Keep the mapping in one tracked source.
