---
status: done
---
# 003 — Wire and install commit guards

objective: invoke the shared guard from normal commit and merge-commit hooks
and install both hooks while leaving the mapping file out of target projects.

criteria:
- [x] pre-commit calls the shared guard before staged/touched checks.
- [x] pre-merge-commit calls the shared guard without imposing the staged/touched gate on merges.
- [x] Installer copies each executable hook/helper, declares them in templates/touched, but does not copy .context/agent-branches.
- [x] Each hook has a context document linked to ADR-0012; CATALOG is synchronized.

dependencies: goal/005-agent-branch-lock/002-enforcement.md
units: hooks/pre-commit, hooks/pre-commit.md, hooks/pre-merge-commit, hooks/pre-merge-commit.md, installer/install.sh, installer/templates/, CATALOG.md
inherited assumptions: repositories without the map remain unaffected by the new checks.
objective test: inspect installed target's hook files and verify its .context/agent-branches is absent.
