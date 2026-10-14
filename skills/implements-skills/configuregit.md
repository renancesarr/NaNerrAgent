# Skill: configuregit

## Trigger
Executed ONLY when:
1. An agent initializes in a fresh workspace/container.
2. The agent needs to switch context to a different model-branch (e.g., `dev-ai-codex`).
3. A divergence in `.context/NOW.md` requires identity re-validation.

## Context & Laws
- **Visibility:** `implements-skill`. Only accessible via `implement` or orchestration layer.
- **Law:** Never uses `--global`. Identity is strictly local to the workspace to prevent cross-agent pollution.
- **Law:** Branch lock must be verified before identity injection.

## Execution Steps
1. **Verify Branch Lock:** 
   - Read `.context/NOW.md` to find the expected `target_branch`.
   - Run `git branch --show-current`. 
   - If mismatch -> HALT. Write to `.context/pending-human.md` with `because: branch divergence detected`.
2. **Inject Identity:**
   - Extract `agent_name` from orchestration env var or `.context/NOW.md`.
   - Run: `git config user.name "${agent_name} Agent"`
   - Run: `git config user.email "${agent_name}@naner-orchestrator.local"`
3. **Verify Remote & Auth:**
   - Run `git fetch --dry-run` to ensure SSH/PAT auth is valid for the shared account.

## Verification (QA Gate)
- `git config user.name` MUST return exactly `"${agent_name} Agent"`.
- `git config user.email` MUST return exactly `"${agent_name}@naner-orchestrator.local"`.
- `git status` MUST show clean working tree (unless mid-task).
- Log the execution in `.context/log/NNN-*.md` with the injected identity.