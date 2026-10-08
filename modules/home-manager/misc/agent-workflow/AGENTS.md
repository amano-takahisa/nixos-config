# Shared coding-agent guidance

- Read the repository's `AGENTS.md`, README, and relevant development docs before changing code. Follow the repository's own commands and conventions.
- Check `git status` first and preserve unrelated user changes. Reuse the current checkout when switching tools for one task; use a separate branch and worktree for concurrent implementation.
- When a repository has `flake.nix`, use its development environment (normally through direnv) for project tools. Ask before creating or editing `flake.nix`.
- Choose the amount of planning to fit the task: implement a clear small change directly; persist a plan for multi-step work that spans sessions; clarify ambiguous or architecture-shaping decisions before implementation.
- Verify behavior against the acceptance criteria. For user-visible web changes, run the app and inspect the affected flow in a browser when the repository provides a usable browser setup.
- Report what changed, what you verified, and any remaining uncertainty. Do not claim checks passed when they were not run.
- Follow the repository's GitHub workflow for branches, commits, CI, and pull requests. Never merge a pull request without explicit authorization.
- For oh-my-pi browser checks on this NixOS host, read `~/.omp/agent/BROWSER.md` before starting Chrome or using the browser tool.
