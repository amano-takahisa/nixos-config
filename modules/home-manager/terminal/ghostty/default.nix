{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      # ctrl + shift + , to reload ghostty settings.
      # https://ghostty.org/docs/config/reference
      adjust-cursor-thickness = 6;
      # Explicit font-family avoids relying on Ghostty's built-in default
      # ("JetBrains Mono"), which no longer exists as a plain family since
      # the standalone jetbrains-mono package was dropped in favor of the
      # Nerd Font variant — an unset font-family fell back unpredictably.
      font-family = [
        "HackGen Console NF"
        "Noto Sans Mono CJK JP"
      ];
      font-feature = [
        "-calt"
        "-liga"
        "-dlig"
      ];
    };
  };
}


