# NOW
objective: resolve LOG 023 review findings and integrate dev-ai
stage: fixes applied on dev-ai-zcode (merge of origin/dev-ai in progress)
step: run installer + identity suites, push, request independent re-review
status: in-progress

## Current understanding
All six LOG 023 findings fixed in the merge resolution: ADR goal-folder
renumbered 0012→0015 (catalog notes pre-merge LOG refs); pre-commit branch
gate moved before the empty-index exit (empty commits on protected branches
now blocked); installer merge test creates a real two-parent merge; AGENTS.md
reconciled with the integrated identity contract (dedicated worktree resume
rule, no agent identity on feature branches, published-claim protocol with
tie-break and loser-stop); goal/004 micros dogfood owner: frontmatter.

## Decisions that change the future
- ADR-0015 (goal/) is the renumbered ex-0012; base ADR-0012 is agent
  branch identity. LOG entries stay append-only (refs disambiguated in
  ADR-CATALOG).
- A micro claim counts only once pushed to origin; competing claims resolve
  by earlier published claim commit; loser marks status: abandoned.
- Agents commit only on their mapped dev-ai-<agent> branch; feature/<slug>
  branches never carry a mapped agent identity.

## Immediate next step
Run `bash installer/test-install.sh` (expect ALL GREEN incl. new empty-commit
and two-parent-merge asserts), push dev-ai-zcode, open PR to dev-ai for the
independent re-review LOG 023 requires.

## Blockers
—
