---
name: parallelize
description: Assess whether independent investigation or implementation can run concurrently and define safe ownership and integration steps.
---

Use parallel work only when tasks are independently useful and concurrency
reduces elapsed time. Parallel investigation is usually low risk. Before
parallel implementation, check dependencies and shared interfaces, schemas,
runtime behavior, and test data; disjoint filenames alone are not sufficient.

Give each worker one bounded outcome, acceptance criteria, verification
commands, and an owner for integration. Concurrent edits must use isolated
branches and worktrees; separate sessions sharing a checkout do not isolate
edits. If the current tool cannot isolate those
changes, work sequentially. Keep one integrator responsible for reviewing the
combined diff and rerunning relevant checks.

Dispatch only tasks whose prerequisites are available in their assigned base
revision. Bound concurrency by the host's capacity and avoid scheduling two
workers to change the same shared contract. Give workers an absolute working
directory and require their commands to stay there. Keep shared progress records
under the integrator's ownership. Collect each worker's branch/revision or diff,
acceptance evidence, check results, and blockers before integration. When called
by `execute-plan`, follow its delegation contract and independent review cycle.

Use the host's native subagent or worktree features when available. Summarize
results and unresolved conflicts. Do not commit, push, open or merge pull
requests, or delete worktrees unless the user or repository workflow
authorizes it. Never auto-merge parallel work.
