---
unit: installer/templates/
decisions: [ADR-0011, ADR-0012]
last-sync: 2026-10-09
---
# Installer templates
responsibility: supplies the zeroed catalogs and context skeleton for target
projects, including the touched manifest required for the installed hooks.
interface: files consumed by installer/install.sh.
dependencies: hooks installed by installer/install.sh; ADR-0011 and ADR-0012.
example: touched declares pre-commit, check-agent-branch.sh, and
pre-merge-commit so the target's first commit passes the flow gate.
notes: agent-specific mapping is intentionally absent; target projects set
their own branch policy.
