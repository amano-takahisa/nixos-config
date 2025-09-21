{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      scrolloff = 8;
      signcolumn = "yes";
      updatetime = 50;
      colorcolumn = "80";
    };
  };
}
