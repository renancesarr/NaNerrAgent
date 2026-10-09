---
unit: hooks/pre-merge-commit
decisions: [ADR-0012]
last-sync: 2026-10-09
---
# Pre-merge commit gate
responsibility: checks the effective agent identity and current branch before
Git creates an automatic merge commit.
interface: executable Git hook configured by core.hooksPath=hooks.
dependencies: check-agent-branch.sh, .context/agent-branches.
example: ai-codex may create a merge commit on dev-ai-codex; a mismatched name,
email, or branch is rejected.
notes: it deliberately does not run the staged/touched gate on merge contents.
Projects without the agent map have no agent-specific merge restriction.
