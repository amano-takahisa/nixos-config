{ lib, pkgs, mcp-servers-nix, llm-agents, ... }:

let
  skillsDir = ./skills;
  skillNames = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir skillsDir)
  );
  skillFileEntries = builtins.listToAttrs (map
    (name: {
      name = ".claude/skills/${name}";
      value.source = skillsDir + "/${name}";
    })
    skillNames);

  hooksDir = ./hooks;
  hookNames = builtins.attrNames (
    lib.filterAttrs (_: type: type == "regular") (builtins.readDir hooksDir)
  );
  hookFileEntries = builtins.listToAttrs (map
    (name: {
      name = ".claude/hooks/${name}";
      value.source = hooksDir + "/${name}";
    })
    hookNames);
in
{
  # Apps (Slack, Claude Code, etc.) sometimes replace the home-manager symlink with a
  # regular file. This runs before home-manager writes symlinks to restore the correct state.
  home.activation.fixMimeappsList = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    if [ -f "$HOME/.config/mimeapps.list" ] && [ ! -L "$HOME/.config/mimeapps.list" ]; then
      $DRY_RUN_CMD rm "$HOME/.config/mimeapps.list"
    fi
  '';

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
  };

  home.file = skillFileEntries // hookFileEntries // {
    ".claude/CLAUDE.md".source = ./CLAUDE.md;
  };

  programs.claude-code = {
    enable = true;
    package = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
    settings = {
      theme = "dark";
      autoUpdates = false;
      includeCoAuthoredBy = false;
      autoCompactEnabled = false;
      enableAllProjectMcpServers = true;
      feedbackSurveyState.lastShownTime = 1754089004345;
      permissions = {
        deny = [
          "Bash(rm -rf /*)"
          "Bash(rm -rf /)"
          "Bash(sudo rm -:*)"
          "Bash(chmod 777 /*)"
          "Bash(chmod -R 777 /*)"
          "Bash(dd if=:*)"
          "Bash(mkfs.:*)"
          "Bash(fdisk -:*)"
          "Bash(format -:*)"
          "Bash(shutdown -:*)"
          "Bash(reboot -:*)"
          "Bash(halt -:*)"
          "Bash(poweroff -:*)"
          "Bash(killall -:*)"
          "Bash(pkill -:*)"
          "Bash(nc -l -:*)"
          "Bash(ncat -l -:*)"
          "Bash(netcat -l -:*)"
          "Bash(rm -rf ~:*)"
          "Bash(rm -rf $HOME:*)"
          "Bash(rm -rf ~/.ssh*)"
          "Bash(rm -rf ~/.config*)"
        ];
        # flake.nix の新規作成・更新は常にユーザー確認を求める。
        # ただし acceptEdits/bypassPermissions/Auto mode ではこの一覧だけでは
        # 確認が省略され得るため、真の強制力は hooks.PreToolUse 側で担保する。
        ask = [
          "Edit(**/flake.nix)"
          "Write(**/flake.nix)"
        ];
      };

      # Auto mode の分類器にも、flake.nix の変更はユーザーの明示的な確認なしに
      # 進めてはいけないことを伝える(ユーザー意図によって解除されない領域)。
      autoMode.hard_deny = [
        "$defaults"
        "flake.nix の新規作成・更新は、ユーザーが事前に一括承認していても、その都度明示的な確認を必ず取ること。"
      ];

      hooks = {
        PreToolUse = [
          {
            matcher = "Write|Edit";
            hooks = [
              {
                type = "command";
                command = ''bash "$HOME/.claude/hooks/guard-flake-nix.sh"'';
                timeout = 10;
              }
            ];
          }
        ];
        SessionStart = [
          {
            hooks = [
              {
                type = "command";
                command = ''bash "$HOME/.claude/hooks/remind-dev-env.sh"'';
                timeout = 10;
              }
            ];
          }
        ];
      };
    };


    mcpServers =
      (mcp-servers-nix.lib.evalModule pkgs {
        programs = {
          context7.enable = true;
          playwright.enable = true;
          nixos.enable = false; # Disabled due to dependency conflict with mcp version
          serena = {
            enable = true;
            args = [
              "--context"
              "ide-assistant"
              "--enable-web-dashboard"
              "False"
            ];
          };
        };
      }).config.settings.servers;
  };
}
