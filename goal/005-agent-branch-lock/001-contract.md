---
status: done
---
# 001 — Agent branch identity contract

objective: define Codex and ZCode's fixed branches and Git identities in the
system instructions and record why the latest branch decision supersedes the
older feature-branch proposal.

criteria:
- [x] Codex is assigned only to dev-ai-codex and ai-codex <dev-ai-codex@nanerr.local>.
- [x] ZCode is assigned only to dev-ai-zcode and ai-zcode <dev-ai-zcode@nanerr.local>.
- [x] AGENTS says to stop before work/commit when the current branch is wrong.
- [x] ADR captures the branch/identity binding and alternatives.

dependencies: none
units: AGENTS.md, BACKLOGS/004-agent-identity-config.md, docs/adr/0012-agent-branch-identity.md, ADR-CATALOG.md
inherited assumptions: latest user instruction selects exact agent branches over BACKLOGS/002's feature-branch option; ZCode changes remain owned by its agent.
objective test: inspect the accepted ADR and AGENTS text; both specify Codex's exact branch and identity without contradicting the latest instruction.
