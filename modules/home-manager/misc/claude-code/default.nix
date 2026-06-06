{ pkgs, mcp-servers-nix, llm-agents, ... }:

{
  home.file.".claude/skills/grill-me/SKILL.md".text = ''
    ---
    name: grill-me
    description: 計画やデザインについて、共通理解に達するまでユーザーに徹底的にインタビューし、意思決定ツリーの各分岐を解決する。
    ---

    共通理解に達するまで、この計画のあらゆる側面について徹底的にインタビューしてください。意思決定ツリーの各分岐を順にたどり、決定事項間の依存関係を一つずつ解決してください。各質問には、あなたの推奨回答も提示してください。質問は一度に一つずつ行ってください。
  '';

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
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
