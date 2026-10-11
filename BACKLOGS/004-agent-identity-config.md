---
id: 004
status: open
type: future-implementation
target-units: [AGENTS.md, installer/, skills/implements-skills/configuregit.md, .context/, GitHub PR workflow]
created: 2026-10-08
source: user request (LOG 020)
---
# Agent identity and configuration selection

## Objective
Give each CLI agent a deterministic way to identify itself and select its
Git and GitHub identity, without leaking configuration between agents,
worktrees, or target projects.

## Confirmed decisions
- Codex Git author: `name = ai-codex`, `email = dev-ai-codex@nanerr.local`.
- Codex is restricted to `dev-ai-codex`; ZCode is restricted to `dev-ai-zcode`.
- ZCode Git author: `name = ai-zcode`, `email = dev-ai-zcode@nanerr.local`.
- Git author identity is set per linked worktree and checked against the agent branch map before commit.
- Codex works only on `dev-ai-codex` and proposes changes to `dev-ai` by PR.
- Git commit identity and authenticated GitHub PR identity are separate:
  Git name/email label commits; GitHub authentication identifies the PR actor.
- Every PR must be verified by an identity other than its author: another
  agent or the human.

## Scope to resolve
- How an agent detects its identity reliably across Codex, ZCode, and OpenCode.
- The repository map now binds Codex and ZCode IDs to Git name/email and branch;
  authenticated GitHub actors remain a separate mapping.
- Extending per-worktree Git identity setup to additional supported agents and
  fresh runtime environments without changing another agent's configuration.
- Authenticated PR identity per agent; a separate GitHub App per agent is a
  candidate, subject to permissions and required-review behavior.
- Reliable runtime detection for every CLI and policy for agents that are not
  present in the repository's identity map.
- Selecting authenticated GitHub actors and machine-local credentials for each CLI.

## Existing draft
`skills/implements-skills/configuregit.md` is present but untracked. Review
and reconcile it during implementation; it is not yet an accepted or
cataloged contract.

## Acceptance criteria
- [x] A Codex worktree on `dev-ai-codex` resolves to `ai-codex`
      `<dev-ai-codex@nanerr.local>`; ZCode follows the equivalent branch/name/email rule.
- [x] Codex's effective Git identity is isolated from other agents and is
      verifiable before its first commit; no global Git identity is changed.
- [x] Codex and ZCode resolve their declared Git identity and branch;
      unknown or conflicting identity stops before commit.
- [ ] A PR's authenticated GitHub actor is distinguishable from the commit's
      author metadata and maps to the implementing agent.
- [ ] The PR targets `dev-ai`, and approval/verification is recorded by a
      different agent identity or the human before integration.
- [ ] Credentials and private keys are not stored in the repository.

## Open questions
1. What trusted runtime signal identifies the current agent in each CLI?
2. Where does the identity map live, and which fields are repo-local versus
   machine-local?
3. What Git config mechanism isolates identity across linked worktrees?
4. Should each agent use its own GitHub App, or another authenticated actor?
5. Which server-side GitHub rules enforce distinct PR author and reviewer,
   including when the reviewer is another agent?
