# 013 — English conversion (large)
when: 2026-10-08
input: user decision — convert everything to English (universal language),
       mainly what gets installed
classification (conter, BEFORE): large — changes understanding across all
       units: laws, 9 skills (renamed), installer, catalogs, ADRs,
       backlogs, specs
scope decided with user: skill NAMES renamed to English (clarify,
       decompose, model-domain, catalog, implement, verify-objective,
       contain, capture-human, audit); LOG history 001–012 stays
       Portuguese (authentic append-only record); IDEA.md and
       DELTA_VERSION.md both converted; pending-human fields become
       because:/concept: (hook updated in sync); new LOG entries in
       English from 013 on
implements: none applicable — docs/scripts translation, no new deps
output: fully English system; ZCode symlinks swapped to new names;
       installer v3 with English templates and output
evidence:
  $ installer/test-install.sh → PASS ×20 → ALL GREEN (0 failures),
  including gate blocks-without-because and passes-with-because (now
  tested natively in the suite)
  $ symlinks: 9 in ~/.agents/skills/* (new names), each SKILL.md
  frontmatter `name:` matches its directory
  $ grep for Portuguese skill names across live units (excluding
  Portuguese LOG history 001–012 and the historical audit report):
  none found
  commit of this entry passes the gate: staged ⊆ .context/touched
  (touched covers both renamed and removed paths)
note: LOG history 001–012 and docs/auditorias/001 stay Portuguese by
  scope decision (authentic record); from 014 on everything is English
next: cross-verification to dev-ai; pending audit findings 1–2; backlogs
