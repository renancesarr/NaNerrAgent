# 014 — promotion: dev-ai-zcode → dev-ai → main (medium)
when: 2026-10-08
input: user decision — everything goes up to dev-ai and main, since this
       is the project of reference
classification (conter, BEFORE): medium — changes the promotion state of
       all branches; git merges + one LOG record
note on cross-verification: the installer (LOG 010/012) and English
       conversion (LOG 013) did not go through a separate-agent
       verification. The user explicitly authorized the promotion — the
       human IS the release gate for main (BACKLOGS/002 rule). Recorded
       here as an accepted deviation: verifier = human.
what: dev-ai ← dev-ai-zcode (--no-ff) · main ← dev-ai (--no-ff) ·
       all pushed to origin
next: Codex/OpenCode branch from updated dev-ai; pending audit findings
       1–2, BACKLOGS/001, rest of 002
