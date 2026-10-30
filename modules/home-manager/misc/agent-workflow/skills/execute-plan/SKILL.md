---
name: execute-plan
description: Execute a saved implementation plan through parent coordination, parallel implementation workers, independent review, verification, and focused local commits.
---

Use the plan named by the user, or the unambiguous active plan in the current
Issue or `docs/plans/`. Ask which plan to execute only when the target is
unclear. Read its scope, acceptance criteria, dependencies, and repository
instructions before starting. Invocation authorizes focused local commits for
this execution unless the user says otherwise; it does not authorize pushing,
opening a pull request, merging, or deployment.

## Roles and model selection

The invoking agent is the parent and integration owner. It reads the full plan,
resolves dependencies, assigns bounded tasks, dispatches reviews, and owns the
combined result and plan updates. Prefer delegating implementation to native
subagents over doing all tasks in the parent when delegation is available.

Use the host's configured agents and model-selection capabilities. Prefer a
mid-tier model for the parent, lightweight models for bounded implementation,
and a mid-tier or stronger model for independent review. Respect explicit user
model choices. Check available roles and model identifiers rather than inventing
them; a background-processing role is not necessarily an implementation worker.
Model names and provider settings belong in the host configuration, not this
shared skill. Do not change persistent model settings as part of execution.

Skill invocation does not itself switch the parent model. Report the actual
parent and worker/reviewer selection when exposed by the host, or state that
it is unknown. If a preferred model is unavailable, use available models and
state the limitation. If native delegation is unavailable, implement serially
and perform an explicit self-review, reporting that independent review was not
possible. Do not claim that reading a review skill starts a separate agent.

## Execution loop

Continue until all in-scope tasks and final verification are complete. A task
completion, commit, worker completion, or progress report is not a reason to
end the turn or ask whether to continue.

1. Select unfinished tasks whose dependencies are satisfied. Use `next` for
   each coherent implementation task; its one-task boundary defines the work
   unit, not the stopping point of this execution.
2. Use `parallelize` to dispatch independent ready tasks concurrently, within
   the host's capacity. Give each implementation worker the task contract below.
   Concurrent implementation requires separate branches and worktrees;
   otherwise dispatch tasks sequentially. Workers implement and run relevant
   checks, using `verify-change` for user-visible behavior. They return results
   to the parent rather than marking the shared plan complete.
3. For each returned task, inspect its diff and evidence, then dispatch a
   separate reviewer using `review-changes`. Give the reviewer the task contract,
   base and resulting commit or exact diff, worktree path, and verification
   results. The reviewer must inspect the implementation, report actionable
   findings and unverified criteria, and not edit files. Return findings to the
   implementation worker for fixes and checks, then have the reviewer inspect
   the revised result. If the same blocker recurs without new evidence, have
   the parent diagnose it or reassign to a more capable available worker;
   do not repeat an unchanged delegation indefinitely. Continue unrelated tasks.
4. Update the plan with verified progress and check results. Use `commit` at
   each coherent, independently useful boundary after relevant checks pass.
   Integrate reviewed worker changes locally, resolve conflicts, and verify
   the combined behavior before marking tasks complete. Worker commits are
   transfer artifacts, not proof of acceptance. Normally commit one completed
   task with its progress update. Split a large
   task only at meaningful verified milestones; combine tiny inseparable tasks
   when that makes a clearer commit. Avoid committing known-broken intermediate
   states. For parallel work, the integration owner verifies the combined
   changes before creating an integration commit or retaining worker commits.
5. Re-read remaining tasks and dependencies, then continue immediately with
   the next executable work. A blocked task must not stop unrelated work.

After implementation, dispatch an independent review of the combined change
against the plan using `review-changes`; task reviews do not replace this
integration review. Fix findings within scope, obtain review of the fixes, and
rerun affected checks. Complete
the plan's final verification, record the outcome, and commit any remaining
related changes. Do not mark tasks complete without their acceptance evidence.

## Delegation contract

Give each worker enough context to act without the parent's conversation:

- Task ID, outcome, acceptance criteria, dependencies, and relevant plan excerpts.
- Repository instructions, allowed scope, shared interfaces, and out-of-scope work.
- Absolute worktree path, branch, base revision, and actual verification commands.
- The required result format: task ID and status; worktree, branch and commit(s)
  or diff location; changes made; acceptance evidence and check results; remaining
  risks, blockers, and decisions needed.

Require all worker commands to run in the assigned worktree. Workers must not
switch the parent's checkout, integrate other branches, edit shared plan progress,
or spawn further workers. The parent owns scheduling and shared records. Allow
focused worker commits for transfer under this invocation's commit authorization;
if commits were declined, use a reviewable diff without silently committing.

Reviewers must inspect the exact submitted revision in a stable worktree; do
not run review against files an implementer is still changing. A task's reviewer
must be a separate agent from its implementer. The parent collects the findings,
assigns fixes, and verifies integration rather than treating a worker's success
message or a review verdict as sufficient evidence.

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
