# NOW
objective: implement BACKLOGS/002 remainder (multiagent flow)
stage: done (LOG 019)
step: branch gate live, claim mechanism dogfooded, AGENTS §8 — awaiting cross-verification
status: done

## Current understanding
Multiagent flow complete: topology (since LOG 008) + deterministic
branch gate (ADR-0014). .context/protected-branches (opt-in) makes the
hook block direct commits on dev-ai/main without the human why; merges
skip pre-commit by git design (verified path). Claim via owner: in
micro frontmatter, first-commit-wins. Target projects unaffected (no
file planted). Live evidence: dev-ai blocked an agent commit (LOG 019).

## Immediate next step (active micro path)
goal/004-multiagent-flow/ — all 4 micros done. Next: cross-verification
queue (LOG 015–019) for promotion to dev-ai; then BACKLOGS/003
(brainstorm skill) or audit findings 1–2.

## Decisions that change the future
- Direct commits on dev-ai/main (meta-repo) require because: — the
  human's field; agent commits go via dev-ai-<agent> only
- because-abuse on protected branches is a containment accepted and
  auditable pattern (ADR-0014)
- Installer suite now 24 asserts; whitelist untouched (targets get no
  protected-branches file)

## Blockers
—
