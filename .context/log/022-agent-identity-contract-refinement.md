# 022 — Refine agent Git identity contract

when: 2026-10-09
classification (contain): large — user corrected an established identity contract and asked for deterministic commit checks that support parallel agent work.
clarify: exact map provided by the user: dev-ai-codex / ai-codex / dev-ai-codex@nanerr.local; dev-ai-zcode / ai-zcode / dev-ai-zcode@nanerr.local. No unresolved mapping was inferred. Future missing or ambiguous identity must ask the user and stop.
decompose: goal/005-agent-branch-lock/005-identity-contract-refinement.md.
implements: none applicable because this is repository-level Bash policy and agent documentation, not a target-specific implementation dialect; IMPLEMENTS-CATALOG.md has no matching skill.
validated state: branch dev-ai-codex; clean starting worktree; existing AGENT helper already validates branch, name, email, and optional agent.id before commit and merge commit. Existing pre-commit touched gate checks staged file scope.
changes: updated the authoritative map, exact test fixtures, ADR-0012, AGENTS, backlog, unit docs, catalog, and goal specs. Configured only this linked worktree as agent.id=ai-codex, user.name=ai-codex, user.email=dev-ai-codex@nanerr.local. Global config and ZCode worktree left unchanged.
objective test: `bash -n hooks/check-agent-branch.sh hooks/pre-commit hooks/pre-merge-commit installer/install.sh installer/test-install.sh && installer/test-install.sh`; got `ALL GREEN (0 failures)`, 33 assertions. Both exact identity/branch pairs passed; wrong ID, name, email, branch, unknown identity, detached HEAD, and mismatched merge author were rejected. `git diff --check` passed.
worktree check: branch dev-ai-codex; agent.id=ai-codex; name=ai-codex; email=dev-ai-codex@nanerr.local. Global name/email unchanged. ZCode worktree not modified.
result: pass
sync: updated ADR-0012, AGENTS, backlog, hook/installer docs, CATALOG, goal 005, NOW, and touched manifest.
publication: commit 104e92292b8ccf1ca96febd26ddf856aea1835e1 pushed to origin/dev-ai-codex with the exact Codex identity. GitHub search found no open PR to dev-ai; PR creation again returned 403 Resource not accessible by integration.
