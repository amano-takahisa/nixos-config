{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # neovim related packages can be added here
  ];
  
  programs.neovim = {
    enable = true;
    extraConfig = ''
      set number relativenumber
    '';
    defaultEditor = true;
  };

  # programs.nixvim = {
  # enable = true;
  #   # colorschemes.catppuccin.enable = true;
  #   # plugins.lualine.enable = true;
  # };
}