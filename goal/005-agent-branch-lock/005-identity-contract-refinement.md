---
status: done
---
# 005 — Match Git name and email to the full agent branch

objective: enforce these exact pairs in the pre-commit and pre-merge hooks:
`dev-ai-codex` / `ai-codex` / `dev-ai-codex@nanerr.local`, and
`dev-ai-zcode` / `ai-zcode` / `dev-ai-zcode@nanerr.local`.

criteria:
- [x] The authoritative map contains exactly the agreed Codex and ZCode rows.
- [x] Both hooks reject a wrong branch, name, email, or mapped agent ID.
- [x] AGENTS tells an agent to ask and stop when identity or mapping is
      ambiguous; it must not infer an identity.
- [x] This Codex worktree uses its branch's name/email in worktree config only.
- [x] ADR, unit docs, catalog, LOG, NOW, and touched manifest agree.

dependencies: goal/005-agent-branch-lock/004-verify-and-configure.md
units: .context/agent-branches, AGENTS.md, hooks/check-agent-branch.sh,
installer/test-install.sh, docs/adr/0012-agent-branch-identity.md
inherited assumptions: current branch is dev-ai-codex; ZCode checkout and
configuration remain untouched.
objective test: run installer/test-install.sh and prove the exact pairs pass,
all individual mismatch cases fail, and the Codex worktree retains its global
Git identity unchanged.
