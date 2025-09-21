{ ... }:

{
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = [
      # Toggle relative line numbers
      {
        mode = "n";
        key = "<F3>";
        action = "<cmd>set relativenumber!<cr>";
        options = {
          desc = "Toggle relative line numbers";
        };
      }
      # Buffer navigation
      {
        mode = "n";
        key = "<C-k>";
        action = "<cmd>bprevious<cr>";
        options = {
          desc = "Previous buffer";
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<cmd>bnext<cr>";
        options = {
          desc = "Next buffer";
        };
      }
      # Clear search highlighting
      {
        mode = "n";
        key = "<Esc><Esc>";
        action = "<cmd>nohlsearch<cr>";
        options = {
          desc = "Clear search highlighting";
        };
      }
      # Caret movement
      {
        mode = "n";
        key = "j";
        action = "gj";
        options = {
          desc = "Move down by display line";
        };
      }
      {
        mode = "n";
        key = "k";
        action = "gk";
        options = {
          desc = "Move up by display line";
        };
      }
    ];
  };
}
