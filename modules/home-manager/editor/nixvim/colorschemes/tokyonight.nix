{ ... }:

{
  programs.nixvim = {
    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "night";
        transparent = false;
        terminal_colors = true;
      };
    };
  };
}


