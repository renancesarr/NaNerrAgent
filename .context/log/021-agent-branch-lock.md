# 021 — fixed agent branch and Git identity lock (large)

when: 2026-10-09
original-prompt: "é obrigatorio o codex se manter na sua propria branch, faca essa regra ou skill que obrigue o codex ficar dev-ai-codex o zcode ficar no dev-ai-zcode"; later specified Codex commit identity codex-ai <codex-ai@nanerr.local>.
clarified-prompt: Codex works and commits only on dev-ai-codex as codex-ai <codex-ai@nanerr.local>; ZCode's branch remains dev-ai-zcode; mismatches must stop before commit; the Codex identity must be isolated per worktree; PRs target dev-ai and require independent review.
classification (contain, BEFORE): large — persistent multi-agent policy plus deterministic commit enforcement across AGENTS, hook, mapping, and installer behavior.
ambiguities: exact dev-ai-codex branch vs BACKLOGS/002 feature branches → exact branch chosen by latest explicit user instruction; identity Codex Agent in old backlog vs codex-ai → latest explicit Git config request wins.
unvalidated assumptions: ZCode identity row reuses the existing zcode-ai <zcode-ai@nanerr.local> mapping; ZCode implementation remains outside this task.
implements: none applicable because the change is meta-repository Bash policy and agent instructions, not a target-specific implementation dialect.
output so far: goal/005-agent-branch-lock/ with contract, hook-enforcement, and worktree-identity micros; isolated worktree attached to dev-ai-codex.
next: ADR-0012 and AGENTS policy; then implement and verify the commit-time guard.

contract: ADR-0012 accepted; AGENTS now requires session-start branch/identity checks; Codex identity in BACKLOGS/004 corrected to the latest user value. Micro 001 implemented; hook/map and per-worktree setup remain.

re-decomposition: split enforcement into map/helper, hook/installer integration, and objective-test/worktree-config micros (001–004); each micro now stays within the six-unit limit. Micro 002 implemented provisionally; hook wiring remains.

implementation: map and shared checker in place; pre-commit and pre-merge-commit now call it; installer copies hooks but not the agent map. Context docs and CATALOG synchronized. Micro 003 provisional pending installer tests.

install integration: installer copies the shared checker and pre-merge hook but never the agent map; target behavior remains opt-in. Installer objective cases added for both mappings, wrong branch/email, unknown identity, detached HEAD, and merge commits. Micro 003 implemented; verification remains.

verification finding: initial suite found the new installed hook/helper files absent from templates/touched, so bootstrap commit failed; fixed template declarations and clarified that map-less targets follow project branch rules.

contract refinement: AGENTS now configures worktree identity when branch is correct and halts only on a branch mismatch; BACKLOGS/004 no longer lists the resolved branch/config scope as open.

## verify-objective
expected: the installer target bootstraps without an agent map; mapped Codex/ZCode identities pass only on their assigned branches; wrong branch/email, unknown reserved identity, detached HEAD, and wrong-author merge commits fail; Codex worktree config is isolated and global config stays unchanged.
command: bash -n hooks/check-agent-branch.sh hooks/pre-commit hooks/pre-merge-commit installer/install.sh installer/test-install.sh && installer/test-install.sh
got: ALL GREEN (0 failures); 31 PASS assertions, including the target's first commit, both allowed identities, all mismatch cases, detached HEAD, and merge-commit rejection.
result: pass
command: git branch --show-current; git config --worktree --get agent.id; git config user.name; git config user.email; git config --global --get user.name; git config --global --get user.email; git config --local --get user.name; git config --local --get user.email
got: dev-ai-codex; codex-ai; codex-ai; codex-ai@nanerr.local; Renan Rabelo and 19899076+renancesarr@users.noreply.github.com unchanged globally; shared local identity remains zcode-ai <zcode-ai@nanerr.local>.
result: pass
command: git diff --check
got: no output; exit 0
result: pass
sync: AGENTS.md and hooks/installer context docs link ADR-0012; CATALOG and ADR-CATALOG updated; templates/touched declares installed hooks; target installer remains free of the meta agent map.
implements: none applicable — infrastructure shell policy with no target-specific dialect.
next: commit on dev-ai-codex, push, and open a PR to dev-ai for review by another agent or human.
