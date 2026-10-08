# 001 — system installation (bootstrap)
when: <DATE>
how: the meta-repo's installer/install.sh planted AGENTS.md, the pre-commit
      gate (core.hooksPath=hooks), zeroed catalogs and fresh .context.
      Core skills are global per CLI (meta-repo's ADR-0011).
next: first commit via the gate (touched already declares the planted
      files) and first task via contain
