{ pkgs, ...}:

{
  home.packages = with pkgs; [
    neovim
  ];
  # programs.nixvim = {
  # enable = true;
  #   # colorschemes.catppuccin.enable = true;
  #   # plugins.lualine.enable = true;
  # };
}
