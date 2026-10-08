# 017 — backlog 003: brainstorm skill (medium)
when: 2026-10-08
input: user request — backlog a skill that brainstorms to create IDEA and
       GOAL: general explanation, then narrowing questions and adjustment
       rounds until both artifacts exist
classification (conter, BEFORE): medium — one new backlog doc; the skill
       itself is future implementation
clarify-light: ADR-0013 tension resolved in the backlog (goals stay the
       single authority; brainstorm produces both artifacts, objectives
       only in goal/); pipeline position proposed as entry door BEFORE
       contain for project creation
implements: none applicable — docs
output: BACKLOGS/003-brainstorm-skill.md (flow, relationship table with
       existing skills, 4 openings, acceptance criteria), CATALOG +1 line
evidence (verify-objective):
  $ ls BACKLOGS/ → 001 002 003 present
  $ grep -c "^## " BACKLOGS/003-brainstorm-skill.md → sections complete
  $ grep -n "003-brainstorm" CATALOG.md → indexed
  commit of this entry passes the gate (staged ⊆ touched, pending empty)
next: implement 003 (user call) or the pending queue (audit 1–2, 002 rest)
