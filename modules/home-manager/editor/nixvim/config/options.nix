{ ... }:

{
  programs.nixvim = {
    globals.mapleader = " ";  # Set leader key to space

      opts = {
        number = true;
        relativenumber = true;
        shiftwidth = 2;
        tabstop = 2;
        expandtab = true;
        smartindent = true;
        wrap = true;
        scrolloff = 8;
        signcolumn = "yes";
        updatetime = 50;
        colorcolumn = "80";

        # Search settings
        ignorecase = true;
        smartcase = true;
        hlsearch = true;
        incsearch = true;

        # UI settings
        termguicolors = true;
        cursorline = true;
        showmode = false;

        # Backup and swap
        backup = false;
        swapfile = false;
        undofile = true;
      };
  };
}
