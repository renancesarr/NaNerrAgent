---
unit: hooks/pre-commit
decisions: [ADR-0007, ADR-0012]
last-sync: 2026-10-09
---
# Pre-commit gate
responsibility: validates the agent identity/branch map, then requires every
staged path to be declared in .context/touched or covered by pending-human.
interface: executable Git hook configured by core.hooksPath=hooks.
dependencies: check-agent-branch.sh, .context/touched, .context/pending-human.md.
example: a mapped Codex identity on dev-ai-codex proceeds to the touched gate;
the same identity on dev-ai-zcode is rejected.
notes: branch/identity mismatch is a hard block and cannot be waived by
pending-human. Projects without the agent map retain the existing touched gate.
