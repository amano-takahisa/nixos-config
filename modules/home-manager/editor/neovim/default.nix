{ ... }:

{
  programs.neovim = {
    enable = false;
    defaultEditor = false;
    extraConfig = ''
      set number relativenumber
    '';
  };
}
