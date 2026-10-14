---
unit: hooks/pre-commit
decisions: [ADR-0007, ADR-0012, ADR-0014]
last-sync: 2026-10-14
---
# Pre-commit gate
responsibility: validates the agent identity/branch map, then gates protected
branches (before any early exit, covering empty commits), then requires every
staged path to be declared in .context/touched or covered by pending-human.
interface: executable Git hook configured by core.hooksPath=hooks.
dependencies: check-agent-branch.sh, .context/protected-branches,
.context/touched, .context/pending-human.md.
example: ai-codex <dev-ai-codex@nanerr.local> on dev-ai-codex proceeds to the
touched gate; a mismatch in branch, name, or email is rejected first; on a
protected branch even `git commit --allow-empty` is blocked without because:.
notes: branch/identity mismatch is a hard block and cannot be waived by
pending-human. The protected-branch gate runs before the empty-index exit so
`--allow-empty` commits are covered (ADR-0014). Projects without the map or
the protected-branches file retain the plain touched gate.
