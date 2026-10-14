# 019 — implement BACKLOGS/002 remainder (large)
when: 2026-10-08
input: user request — implement backlog 002 (the multiagent remainder:
       branch gate, micro claim, AGENTS amendment)
classification (conter, BEFORE): large — flow law change, deterministic
       gate + AGENTS.md amendment, domain decision → ADR-0014
key design discovery: target projects commit to main BY DESIGN (ADR-0011
       installer flow) — a global branch gate would break every target
       bootstrap. Resolution: opt-in .context/protected-branches (one
       branch per line); meta-repo lists dev-ai+main; targets ship
       without the file and work as before.
openings resolved (recorded in ADR-0014): verifier scope = objective
       test only (unit tests stay with the author, QA-first hierarchy);
       single-agent fallback = human verifies (LOG 014 precedent); race
       window = first-commit-wins, no lock (YAGNI); because-abuse on
       protected branches = containment accepted, audit hunts the
       pattern (because: is human verbatim per capture-human).
implements: none applicable — bash hook + docs
output: goal/004-multiagent-flow/ (4 micros, all done, owner: zcode
       claim dogfooded), ADR-0014 + catalog line, hooks/pre-commit v2,
       .context/protected-branches (dev-ai, main), AGENTS.md §1.4 + §8,
       CATALOG/BACKLOGS/002 synced (implemented)

## Evidence (verify-objective)
  $ installer/test-install.sh → PASS ×24 → ALL GREEN, including the 4
    new branch-gate asserts: unprotected branch passes; protected blocks
    without why; protected passes with why; merge works on protected
  $ LIVE (meta-repo): git checkout dev-ai; agent-flow commit attempt →
    "✋ dev-ai is protected (ADR-0014): direct commits need the human why"
    EXIT=1 — the deterministic block on the real repo
  $ git merge --no-ff on a protected branch (suite assert) → works:
    git skips pre-commit for merges; the verified path stays open
  commit of this entry passes the gate on dev-ai-zcode (unprotected)
next: cross-verification queue (015–019) for promotion to dev-ai; the
      branch gate itself now guards dev-ai/main from direct agent commits
