---
name: next
description: Resume the next incomplete implementation task from the current Issue, plan, or handoff and verify the result.
---

Find the active task in the current request, linked Issue, pull request, or
`docs/plans/`. Prefer the Issue for product goal and acceptance criteria; use a
plan for task order and dependencies. If there are multiple active plans and
no clear target, ask which one to continue.

Before editing, inspect the working tree and relevant project instructions.
Preserve unrelated changes and continue in the current worktree. Implement one
coherent task, respecting its scope and acceptance criteria. If an assumption
or architectural decision has changed, stop and report it before silently
changing the plan.

Run the relevant project checks and use `verify-change` for user-visible
behavior. Update the active plan or Issue with verified progress when it is
already the chosen source of truth. Leave a concise handoff there if work
remains. Do not push, open a pull request, merge, or commit unless the user or
the repository's documented workflow calls for that action.
