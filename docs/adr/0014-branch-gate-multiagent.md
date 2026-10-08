---
id: 0014
status: accepted
supersedes: —
units: [hooks/pre-commit, .context/protected-branches, skills/agents-skills/decompose, AGENTS.md]
---
# Agents commit only on their dev-ai-<agent> branch; protected branches receive verified merges or the human why

## context
Two agents interleaved on the same working tree (LOG 007) proved branch
isolation is structural, not conventional. The topology (dev-ai +
dev-ai-{codex,opencode,zcode}) has lived since LOG 008, but the
protection was convention-only. BACKLOGS/002 remainder asked for a
deterministic gate. Constraint discovered while designing: target
projects commit to main BY DESIGN (installer flow, ADR-0011) — a global
branch gate would break every target bootstrap.

## alternatives
- Block dev-ai/main unconditionally in the hook: rejected — breaks the
  target first-commit flow (ADR-0011) that the same system plants.
- Gate keyed only on pending-human because:: rejected alone — it would
  also break targets, and agents could fill because: to bypass.
- Opt-in protected-branches file (chosen): the hook blocks direct
  (non-merge) commits on listed branches unless because: is filled. The
  meta-repo lists dev-ai and main; targets get no file and work as before.

## consequences
We gain: deterministic branch protection where the topology exists; the
human keeps the release gate (because: = the human's explicit why);
merges skip pre-commit by git design — the verified path stays open;
the claim (owner: in micro frontmatter, first-commit-wins) coordinates
agents without locks (YAGNI).
We give up: the gate cannot distinguish human from agent — an agent
filling because: on a protected branch would pass. containção: accepted;
audit hunts it (because: is human verbatim per capture-human; a filled
because on a protected branch with agent-flow files is a LOG pattern).
Enforcement of merges-by-verifier stays a process rule (LOG 014
precedent: the human authorizes deviations).
