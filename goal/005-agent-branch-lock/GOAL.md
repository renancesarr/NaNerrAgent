---
status: done
---
# 005 — Agent branch and identity lock

objective: Codex commits use ai-codex <dev-ai-codex@nanerr.local> only on
dev-ai-codex; ZCode commits use ai-zcode <dev-ai-zcode@nanerr.local> only on
dev-ai-zcode. The repository refuses
commits when a recognized identity and branch disagree.

success metric: a mismatch is blocked by the installed commit/merge hooks;
a matching Codex identity on dev-ai-codex passes; target projects
without the meta-repository mapping keep existing behavior.

## Map

| micro | objective | depends on | status | objective test |
|---|---|---|---|---|
| 001 | Record the branch/identity contract and its rationale. | — | implemented | AGENTS and ADR state exact Codex and ZCode branch mapping. |
| 002 | Build the authoritative map and reusable identity/branch check. | 001 | implemented | Review map schema; helper rejects mismatch, unknown reserved identity, and detached HEAD. |
| 003 | Wire commit and merge hooks; install them without installing the meta map. | 002 | implemented | Installed hooks call the guard; installer leaves agent map absent. |
| 004 | Exercise the behavior and isolate this Codex worktree identity. | 003 | done | Installer objective suite proves matching pass and mismatch blocks; effective Codex config is branch/name/email scoped. |
| 005 | Align names/emails to the full branch names and clarify ambiguity handling. | 004 | done | Hook suite proves exact branch, name, and email pairs; AGENTS requires asking when mapping is ambiguous. |
