---
name: execute-plan
description: Execute all remaining tasks in a saved implementation plan, coordinating sequential or parallel work, verification, progress updates, and focused local commits.
---

Use the plan named by the user, or the unambiguous active plan in the current
Issue or `docs/plans/`. Ask which plan to execute only when the target is
unclear. Read its scope, acceptance criteria, dependencies, and repository
instructions before starting. Invocation authorizes focused local commits for
this execution unless the user says otherwise; it does not authorize pushing,
opening a pull request, merging, or deployment.

## Execution loop

Continue until all in-scope tasks and final verification are complete. A task
completion, commit, worker completion, or progress report is not a reason to
end the turn or ask whether to continue.

1. Select unfinished tasks whose dependencies are satisfied. Use `next` for
   each coherent implementation task; its one-task boundary defines the work
   unit, not the stopping point of this execution.
2. Use `parallelize` when independent work can reduce elapsed time. Delegate
   bounded tasks to native subagents when available. Concurrent implementation
   requires separate branches and worktrees; otherwise implement sequentially.
   Keep one integration owner responsible for the combined result. Worker
   commits may be used for transfer when needed, but are not proof that a task
   is verified or integrated. Integrate local work without merging a PR.
3. Implement and run the relevant checks, using `verify-change` for user-visible
   behavior. Fix failures caused by this work and verify again. Record unrelated
   failures or unavailable checks without claiming they passed.
4. Update the plan with verified progress and check results. Use `commit` at
   each coherent, independently useful boundary after relevant checks pass.
   Normally commit one completed task with its progress update. Split a large
   task only at meaningful verified milestones; combine tiny inseparable tasks
   when that makes a clearer commit. Avoid committing known-broken intermediate
   states. For parallel work, the integration owner verifies the combined
   changes before creating an integration commit or retaining worker commits.
5. Re-read remaining tasks and dependencies, then continue immediately with
   the next executable work. A blocked task must not stop unrelated work.

After implementation, review the combined change against the plan using
`review-changes`, fix findings within scope, and rerun affected checks. Complete
the plan's final verification, record the outcome, and commit any remaining
related changes. Do not mark tasks complete without their acceptance evidence.

## Boundaries and handoff

Resolve routine implementation choices within the agreed scope. Ask for a
decision when requirements or architectural assumptions materially change;
continue independent work while waiting. Respect repository-specific approvals,
including any confirmation required for `flake.nix` changes or commits.

Stop when everything is complete, the user asks to stop, or no remaining work
can proceed without a user decision, permission, external dependency, or an
execution limit. Do not repeatedly retry an unchanged blocker. Before stopping
or switching sessions, save completed and remaining tasks, important decisions,
commit references, check results, blockers, and the next useful action in the
plan. Report these concisely to the user. Resume from that durable state when
asked; the skill itself does not restart a terminated session.
