---
name: write-plan
description: Create, list, or inspect a persistent implementation plan for multi-step work that spans dependencies or sessions.
---

Use `docs/plans/` when work has multiple dependent steps, needs coordination,
or must resume across sessions. For a small, clear change, work from the Issue
or request without creating a plan. Read the directory README, relevant ADRs,
and current code before planning.

For a new plan, define the end goal and out-of-scope work. Split the work into
independently verifiable tasks with concise acceptance criteria, dependencies,
and the files or interfaces each task will change. Include the repository's
actual verification commands; do not assume `nix develop -c check` exists.
Keep the plan self-contained enough for another CLI session to resume.

Reuse decisions already made in the conversation. Ask only about unresolved
choices that materially affect scope or design. Create or update a plan when
the user asks for one; do not turn every implementation request into a plan.

For `list`/`ls`, show each plan's status and progress. For a plan number, show
that plan. Otherwise create a new plan using the next available number and the
repository's filename convention.
