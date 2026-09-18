# oh-my-pi (omp) coding agent for the msi host.
#
# The package is built from the pinned `oh-my-pi` flake input (Bun + Rust, no
# binary cache), so the first build after a lock update is slow.
# `programs.omp.package` defaults to that input's package; declarative settings
# go in `programs.omp.settings` and are written to ~/.omp/agent/config.yml.
#
# The home-manager module manages only the package and config.yml. Everything
# else omp discovers natively is wired here with explicit `home.file` entries,
# mirroring modules/home-manager/misc/claude-code/default.nix:
#
#   ~/.omp/agent/AGENTS.md            user-level context file (CLAUDE.md 相当)
#   ~/.omp/agent/agents/*.md          task subagent definitions (`task` tool)
#   ~/.omp/agent/skills/*/SKILL.md    skills (`/skill:<name>`, `skill://` URLs)
#   ~/.omp/agent/commands/*.md        bare `/name` slash commands
#   ~/.omp/agent/hooks/pre/*.ts       tool_call / before_agent_start hooks
#
# The first four go through `home.file` (store symlinks). Hooks must be real
# files: omp's native hook discovery enumerates `hooks/pre` with
# `Dirent.isFile()`, which is false for a symlink, so a `home.file` hook is
# silently ignored. They are installed by an activation script instead, the
# same way the upstream module installs config.yml.
#
# `.claude/agents` is deliberately not reused: omp skips foreign agent roots
# because their frontmatter is not the OMP task-agent contract.
{ lib, oh-my-pi, ... }:

let
  # One home.file entry per file (`regular`) or per skill directory (`directory`).
  entriesFromDir =
    { dir, prefix, kind }:
    let
      names = builtins.attrNames (
        lib.filterAttrs (_: type: type == kind) (builtins.readDir dir)
      );
    in
    builtins.listToAttrs (
      map
        (name: {
          name = "${prefix}/${name}";
          value.source = dir + "/${name}";
        })
        names
    );

  hooksDir = ./hooks/pre;
  hookNames = builtins.attrNames (
    lib.filterAttrs (_: type: type == "regular") (builtins.readDir hooksDir)
  );
in
{
  imports = [ oh-my-pi.homeManagerModules.default ];

  programs.omp = {
    enable = true;

    # ~/.omp/agent/config.yml is installed as a writable regular file, so omp
    # can still rewrite it at runtime (`/settings`, onboarding). Those runtime
    # changes are reverted to the declared values on the next switch.
    settings = {
      modelRoles = {
        # 対話・調整役 (親エージェント)。設計を厚くしたいときは `/model @plan`。
        default = "opencode-go/deepseek-v4.1-flash";
        # 設計・壁打ち (grill-me / plan スキル)。
        plan = "opencode-go/deepseek-v4-pro:high";
        # 軽量なバックグラウンド処理 (タイトル生成など)。
        smol = "opencode-go/deepseek-v4.1-flash";
        # implementer サブエージェント (コード特化)。
        worker = "opencode-go/kimi-k2.7-code:high";
        # reviewer サブエージェント (推論重視)。
        review = "opencode-go/deepseek-v4-pro:high";
      };
      defaultThinkingLevel = "auto";

      # implementer を spawn ごとの隔離ワークスペースで動かし、成果を patch として
      # 親ツリーへ適用する (fanout スキルの前提)。
      task.isolation.enabled = true;

      # 以下は omp 側で `/settings` から設定していた UI 設定。
      symbolPreset = "nerd";
      composer.shape = "band";
      theme = {
        dark = "titanium";
        light = "light";
      };
      setupVersion = 2;
    };
  };

  home.file =
    {
      ".omp/agent/AGENTS.md".source = ./AGENTS.md;
    }
    // entriesFromDir {
      dir = ./agents;
      prefix = ".omp/agent/agents";
      kind = "regular";
    }
    // entriesFromDir {
      dir = ./skills;
      prefix = ".omp/agent/skills";
      kind = "directory";
    }
    // entriesFromDir {
      dir = ./commands;
      prefix = ".omp/agent/commands";
      kind = "regular";
    };

  # Hooks are copied as regular files (see the header comment). Renaming or
  # deleting a hook file leaves the previously installed copy behind, so remove
  # it by hand in that case.
  home.activation.ompHooks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "$HOME/.omp/agent/hooks/pre"
    ${lib.concatMapStrings (name: ''
      run install -m 644 ${hooksDir + "/${name}"} "$HOME/.omp/agent/hooks/pre/${name}"
    '') hookNames}
  '';
}
