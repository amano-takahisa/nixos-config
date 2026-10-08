# Shared coding-agent workflow

This directory is the source of truth for the personal guidance and reusable
skills shared by Claude Code, Codex CLI, and oh-my-pi. Edit files here; do not
maintain per-tool copies of the same skill.

## What is shared and what stays tool-specific

Home Manager links the same `AGENTS.md` to each tool's global instruction path
and each skill directory to the discovery paths below:

| Shared source    | Claude Code                | Codex CLI                  | oh-my-pi                      |
| ---------------- | -------------------------- | -------------------------- | ----------------------------- |
| `AGENTS.md`      | `~/.claude/CLAUDE.md`      | `~/.codex/AGENTS.md`       | `~/.omp/agent/AGENTS.md`      |
| `skills/<name>/` | `~/.claude/skills/<name>/` | `~/.agents/skills/<name>/` | `~/.omp/agent/skills/<name>/` |

Model choice, subscription credentials, provider limits, sandbox permissions,
MCP servers, browser drivers, and hooks stay in the configuration for the tool
that owns them. Switching a tool or subscription therefore does not change the
workflow instructions.

## Available skills

| Skill            | Use it for                                                                                     |
| ---------------- | ---------------------------------------------------------------------------------------------- |
| `grill-me`       | Clarify a vague request and produce agreed scope and acceptance criteria.                      |
| `adr`            | Record a durable architecture decision, or inspect and update existing ADRs.                   |
| `write-plan`     | Create or inspect a persistent plan for work that spans multiple steps or sessions.            |
| `next`           | Continue the next incomplete task from an issue or saved plan.                                 |
| `verify-change`  | Run the relevant checks and confirm a user-visible flow.                                       |
| `review-changes` | Review a diff against its acceptance criteria without editing it.                              |
| `parallelize`    | Decide whether bounded independent work can safely run in parallel and coordinate integration. |
| `commit`         | Prepare and make focused local commits following the repository's history.                     |

Invoke a skill using the host's syntax:

| Tool        | Invocation                                                     |
| ----------- | -------------------------------------------------------------- |
| Claude Code | `/grill-me`, `/next`, `/verify-change`, etc.                   |
| Codex CLI   | `$grill-me`, `$next`, `$verify-change`, etc.                   |
| oh-my-pi    | `/skill:grill-me`, `/skill:next`, `/skill:verify-change`, etc. |

Codex's built-in `/plan` changes the current session's planning mode. The
persistent-plan skill is `$write-plan`. Built-in review commands are also
available; `review-changes` supplies the shared review criteria.

## Recommended flow

1. Start from a GitHub Issue or a concrete request. Keep the goal, acceptance
   criteria, and out-of-scope items together. Use `grill-me` only when the
   request leaves a decision that changes the solution.
2. Write an ADR only for a decision that would be costly to revisit. Use
   `write-plan` only when implementation has multiple dependent steps or must
   survive a session boundary. Small tasks need neither.
3. Work on one focused branch. Use a separate worktree when another CLI session
   or agent must work concurrently. When a subscription limit requires a tool
   switch, stop the old session and open the same worktree in the new tool.
4. Use `next` to continue saved work. Keep durable progress in the Issue, plan,
   or pull request so another tool can resume without the old conversation.
5. Run `verify-change`, then `review-changes` or the tool's built-in review.
   Push and open a pull request according to the repository workflow; wait for
   CI and review before merging. Do not auto-merge.
6. Use `commit` when a local commit is wanted. It does not push changes.

## Parallel work

Parallelize independent investigations freely when the result can be summarized
briefly. Parallel code changes need separate worktrees and clearly separated
responsibilities. File globs alone do not prove that tasks are independent:
check shared APIs, schemas, runtime behavior, and test data as well. Keep one
integration owner responsible for reviewing the combined diff and running the
full relevant checks. If the tool cannot isolate concurrent edits, run those
edits sequentially.

## Switching tools and resuming work

Conversation history is not shared across tools. Before switching, leave a
short handoff in the active Issue, plan, or pull-request draft with:

- current goal and acceptance criteria;
- completed work and important decisions;
- remaining work and the next useful action;
- checks already run and their results;
- any running services, ports, or test-data constraints.

Avoid a separate handoff file for a small task. For a long plan, append the
handoff to its work notes. Continue in the same worktree unless work is meant
to happen concurrently.

## NixOS browser setup for oh-my-pi

The oh-my-pi-specific Chrome/CDP instructions are maintained in
`modules/home-manager/misc/oh-my-pi/BROWSER.md` and installed as
`~/.omp/agent/BROWSER.md`. Read them only when using oh-my-pi's browser on this
host; other tools keep using their own browser integrations.
