{ ... }:

{
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    daemon.enable = false;
    settings = {
      theme.name = "catppuccin-mocha-blue";
      inline_height = 0;
      invert = false;
      style = "auto";
    };
    themes = {
      "catppuccin-mocha-blue" = {
        theme.name = "catppuccin-mocha-blue";
        colors = {
          AlertInfo = "#a6e3a1";
          AlertWarn = "#fab387";
          AlertError = "#f38ba8";
          Annotation = "#89b4fa";
          Base = "#cdd6f4";
          Guidance = "#9399b2";
          Important = "#f38ba8";
          Title = "#89b4fa";
        };
      };
    };
  };
}


