# oh-my-pi (omp) coding agent for the msi host.
#
# The package is built from the pinned `oh-my-pi` flake input (Bun + Rust, no
# binary cache), so the first build after a lock update is slow.
# `programs.omp.package` defaults to that input's package; declarative settings
# go in `programs.omp.settings` and are written to ~/.omp/agent/config.yml.
#
# Shared instructions and skills are wired by agent-workflow/default.nix.
# This module retains only oh-my-pi-specific settings, browser guidance, and
# hooks.
#
# Skills and agent definitions go through `home.file` (store symlinks). Hooks must be real
# files: omp's native hook discovery enumerates `hooks/pre` with
# `Dirent.isFile()`, which is false for a symlink, so a `home.file` hook is
# silently ignored. They are installed by an activation script instead, the
# same way the upstream module installs config.yml.
#
# `.claude/agents` is deliberately not reused: omp skips foreign agent roots
# because their frontmatter is not the OMP task-agent contract.
{ lib, oh-my-pi, ... }:

let
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
        plan = "opencode-go/deepseek-v4.1-flash";
        # 軽量なバックグラウンド処理 (タイトル生成など)。
        smol = "opencode-go/deepseek-v4.1-flash";
      };
      defaultThinkingLevel = "auto";

      # NixOS には chrome/chromium が無く、omp 同梱の Chromium も共有ライブラリを
      # 解決できず起動しない (NixOS は FHS を持たないため)。そこで Eval の
      # browser prelude は、nix-shell で起動した Chrome へ CDP で接続させる
      # (起動手順は BROWSER.md)。screenshotDir は人間が確認できる場所に置く。
      browser = {
        cdpUrl = "http://127.0.0.1:9222";
        screenshotDir = "~/Pictures/omp-shots";
      };

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

  home.file = {
    ".omp/agent/BROWSER.md".source = ./BROWSER.md;
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
