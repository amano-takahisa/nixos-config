{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      # ctrl + shift + , to reload ghostty settings.
      # https://ghostty.org/docs/config/reference
      adjust-cursor-thickness = 6;
      font-feature = [
        "-calt"
        "-liga"
        "-dlig"
      ];
    };
  };
}


