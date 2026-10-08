---
name: commit
description: Prepare focused local commits that match the repository's existing commit history.
---

Inspect `git status`, staged and unstaged diffs, and recent commit messages.
Commit only changes related to the requested task; preserve unrelated user
work. Split distinct concerns into separate commits and stage explicit paths.

Do not include secrets. Do not use `git add .` or `git add -A`. If a pre-commit
hook fails, report it and do not bypass it. Do not amend or rewrite published
history. Do not push. If the change includes `flake.nix`, get the user's
confirmation before committing it.

Commit a clearly scoped task without another confirmation when the user has
asked for the task to be committed. If the scope is unclear or spans unrelated
work, show the proposed file groups and messages first.
