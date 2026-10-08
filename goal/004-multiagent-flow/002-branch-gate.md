---
status: done
---
# 002 — branch gate
objective: deterministic protection without breaking targets.
criteria: [x] hook checks .context/protected-branches before the flow
check; [x] because: is the human escape; [x] meta-repo lists dev-ai+main;
[x] suite 24/24 incl. 4 new branch-gate asserts; [x] LIVE: dev-ai blocked
an agent-flow commit (exit 1, ADR-0014 message, LOG 019).
objective test: installer/test-install.sh + live block on dev-ai.
