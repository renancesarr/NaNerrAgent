---
id: 0011
status: accepted
supersedes: —
units: [installer/install.sh, installer/templates/, installer/test-install.sh]
---
# Installer: skeleton copied per project, global skills per machine

## context
Installing the system into new projects required deciding what goes into the
target repo. The target needs the laws (AGENTS.md), the gate and catalogs/
context ZEROED — never the meta-repo's history (DELTA_VERSION, IDEIA,
BACKLOGS, audits, LOG). The 9 skills, however, already have a single source
in the meta-repo with per-CLI symlinks (LOG 002); copying them per project
would create N divergent sources.

## alternatives
- Copy everything (skills included) per project: rejected — breaks DRY;
  evolving a skill would require re-propagation to every repo.
- Symlink from the target pointing to the meta-repo: rejected — the target
  would break in clones without the meta-repo at the same machine path.
- Copied skeleton + global skills (chosen): the target versions only what
  is its own (laws, gate, catalogs, context); skills come from the CLI.

## consequences
We gain: a self-contained target, versionable from the first commit (touched
already comes declaring the planted files); single source of the skills; the
whitelist makes the installer idempotent and unable to leak meta-repo history.
We give up: the target does not document the skills locally (depends on the
configured CLI); projects that diverge from the core solve it via their own
implements-skills, not via forking the agent-skills.

## amendment 1 — existing AGENTS.md and anonymity of targets (2026-10-08)
First real use on a target with its own AGENTS.md: the old content is now
preserved VERBATIM at the end of the new one (before: a conflict requiring
--force + manual merge). A guard by header prevents duplication on re-install
(containment: renewing laws while preserving the tail is deferred until there
is a real upgrade of the laws). And the meta-repo does NOT record target
identity — no path, no stack, no data: records only say "installation
worked". Rejected alternative: registering targets — it would turn the
meta-repo into a tracker of other people's projects, with no gain for the
system.
