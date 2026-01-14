{ ... }:

{
  programs.nixvim = {
    globals.mapleader = " "; # Set leader key to space

    opts = {
      colorcolumn = "79,88,120";
      expandtab = true;
      number = true;
      relativenumber = true;
      scrolloff = 8;
      shiftwidth = 2;
      signcolumn = "yes";
      smartindent = true;
      tabstop = 2;
      updatetime = 50;
      wrap = true;

      # Search settings
      hlsearch = true;
      ignorecase = true;
      incsearch = true;
      smartcase = true;

      # UI settings
      cmdheight = 2;
      cursorline = true;
      showmode = false;
      termguicolors = true;

      # Backup and swap
      backupcopy = "yes";
      swapfile = true;
      undofile = true;

      # Clipboard integration
      clipboard = "unnamedplus";

      # Window
      splitbelow = true;
      splitright = true;

      # Floating window transparency
      pumblend = 20;
      winblend = 20;
    };

    autoCmd = [
      {
        event = [ "FileType" ];
        pattern = [ "gitcommit" ];
        command = "setlocal spell spelllang=en";
      }
      {
        event = [ "BufRead" "BufNewFile" ];
        pattern = [ "*.puml" "*.plantuml" "*.pu" "*.uml" ];
        command = "setfiletype plantuml";
      }
    ];
  };
}
