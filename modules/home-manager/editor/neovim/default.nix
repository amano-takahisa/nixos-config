{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # neovim related packages can be added here
  ];
  
  programs.neovim = {
    enable = false;
    defaultEditor = false;
    extraConfig = ''
      set number relativenumber
    '';
  };
}
