# 021 — git identity: zcode-ai (trivial — fast path)
when: 2026-10-08
classification (conter, BEFORE): trivial — 2 repo-local git config keys,
       zero file changes beyond this LOG entry
what: repo-local identity set to zcode-ai <zcode-ai@nanerr.local>
       (overrides the human's global identity IN THIS REPO ONLY; global
       config untouched). Past commits keep their original author.
why: the multiagent flow needs visible authorship — zcode-ai commits are
       distinguishable from human commits in history and PRs (verifier ≠
       implementer becomes auditable at a glance)
note: a parallel session touched this tree (its flow went to its own
       branch, c8bace4 on dev-ai-codex); per the user, zcode ignores it
       and stays on dev-ai-zcode always. The shared .git/config was
       overwritten by that session; re-set here to zcode-ai. Per-branch
       identity selection remains BACKLOGS/004's future implementation.
note: name normalized to "zcode-ai" per user correction — the diaeresis
       in the original command was a typo
this very commit is the evidence: check its author below
