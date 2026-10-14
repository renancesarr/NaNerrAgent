# 016 — ADR-0013: goals are the single objective home (medium)
when: 2026-10-08
input: user decision — IDEA.md and goals are individually optional; when
       objectives exist, focus on goals; avoid unnecessary abstractions
classification (conter, BEFORE): medium — one ADR + a section in
       decompose + catalog lines; commit straight to dev-ai-zcode (no
       feature branch for medium — containment)
implements: none applicable — docs amendment
output: docs/adr/0013-goals-single-authority.md, decompose section
       "Single home for objectives", ADR-CATALOG line + full-file note
evidence (verify-objective):
  $ grep -n "ADR-0013" skills/agents-skills/decompose/SKILL.md → section
    present with the rule
  $ test -f docs/adr/0013-goals-single-authority.md && grep -c 0013
    ADR-CATALOG.md → file + catalog line
  consistency check on the meta-repo itself: IDEA.md carries vision
  (problem/mechanisms/metrics — no objective list to migrate); goals
  live only in goal/ → the rule already holds here, no rewrite needed
note: installer plants no IDEA/README — targets remain free to have
  either artifact alone; nothing to change there (whitelist untouched)
next: cross-verification queue (LOG 015 + 016); audit findings 1–2;
  BACKLOGS/002 remainder
