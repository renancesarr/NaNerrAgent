# 020 — backlog: agent identity and configuration (medium)

when: 2026-10-08
input: user decision — Codex Git identity is `Codex Agent` /
       `codex@nanerr.local`; the system must identify the active agent and
       choose its configuration
classification (contain, BEFORE): medium — one new backlog unit and catalog
       entry; design questions remain for implementation
scope: identity selection for Git commits and authenticated GitHub PRs;
       Codex works only on dev-ai-codex and opens PRs to dev-ai
implements: none applicable — backlog/spec documentation only
output: BACKLOGS/004-agent-identity-config.md; CATALOG.md entry; NOW updated
related input: an untracked `skills/implements-skills/configuregit.md` draft
       exists; it is recorded for reconciliation, not modified or adopted
evidence (verify-objective):
  $ test -f BACKLOGS/004-agent-identity-config.md
  PASS
  $ rg -n 'BACKLOGS/004-agent-identity-config.md' CATALOG.md
  one catalog entry
  $ git diff --check
  PASS
next: implement BACKLOGS/004 when requested; Codex stays on dev-ai-codex,
      with dev-ai as the PR base
