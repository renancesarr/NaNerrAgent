---
unit: review-fixes
date: 2026-10-14
agent: ai-zcode
---
# LOG 025 — re-review PR #1 findings fixed (tie-break + empty-index test)

Two P2 findings from the independent re-review (outputs/re-review-pr-1-zcode.md):

1. Claim tie-break now a total order (AGENTS.md §8 + ADR-0014):
   (committer date on origin, then commit hash lexicographic). Validated by
   reproduction in a temp bare origin — two claims with identical committer
   date 1791979200 (a455cd4b… ai-codex / 955094c3… ai-zcode) resolve to a
   single winner by hash: 955094c3. Same-second ties always resolve.

2. Empty-commit regression test now exercises the early-exit path:
   flow2.txt is unstaged first, the index is asserted empty (staged_count=0),
   the --allow-empty commit must be rejected AND HEAD unchanged; flow2.txt is
   re-staged for the because: scenario afterwards.

verification:
- bash installer/test-install.sh → ALL GREEN, 38 PASS / 0 FAIL (LOG 024 and
  the PR body said 34 — corrected here; append-only: LOG 024 stays as written).
- mutation check on a /tmp copy: moving the protected gate back AFTER the
  empty-index exit makes the suite FAIL ("protected branch blocks empty
  commit without why (empty index, HEAD unchanged)" → FAIL, 1 FAILURES).
  The suite now detects the regression it previously missed.

next: PR #1 update; await re-review.
