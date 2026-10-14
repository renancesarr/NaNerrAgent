---
unit: installer/install.sh
decisions: [ADR-0011, ADR-0012]
last-sync: 2026-10-09
---
# Project installer
responsibility: installs the agent system and its executable commit hooks
into a target repository while preserving target-owned AGENTS content.
interface: installer/install.sh TARGET [--force].
dependencies: installer/templates/, hooks/pre-commit, hooks/check-agent-branch.sh,
hooks/pre-merge-commit.
example: shared hooks are copied and declared in templates/touched, but
.context/agent-branches is never copied; targets keep their own branch policy.
notes: reinstallation remains opt-in with --force; the target map is a
meta-repository policy file.
