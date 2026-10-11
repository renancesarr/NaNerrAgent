---
unit: installer/test-install.sh
decisions: [ADR-0011, ADR-0012]
last-sync: 2026-10-09
---
# Installer objective test
responsibility: exercises bootstrap, idempotency, the touched gate, and agent
branch identity enforcement in real temporary Git repositories.
interface: installer/test-install.sh; exits nonzero on any failed assertion.
dependencies: installer/install.sh, hooks/check-agent-branch.sh,
hooks/pre-merge-commit.
example: validates exact Codex and ZCode branch/name/email mappings, each
mismatch rejection, detached HEAD rejection, merge rejection, and the no-map
target behavior.
notes: test repositories are temporary and removed on exit.
