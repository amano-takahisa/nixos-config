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
in
{
  home.activation.registerClaudeCodeUrlHandler = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -L "$HOME/.config/mimeapps.list" ]; then
      $DRY_RUN_CMD unlink "$HOME/.config/mimeapps.list"
    fi
    $DRY_RUN_CMD ${pkgs.xdg-utils}/bin/xdg-mime default claude-code-url-handler.desktop x-scheme-handler/claude-cli
  '';

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
  };
  home.file = skillFileEntries;

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
