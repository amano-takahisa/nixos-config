{ ... }:

{
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = [
      # Copy relative file path to clipboard
      {
        mode = "n";
        key = "<leader>y";
        action = "<cmd>let @+ = expand('%')<cr>";
        options = {
          desc = "Copy relative file path to clipboard";
        };
      }
      # Copy absolute file path to clipboard
      {
        mode = "n";
        key = "<leader>Y";
        action = "<cmd>let @+ = expand('%:p')<cr>";
        options = {
          desc = "Copy absolute file path to clipboard";
        };
      }
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
      {
        mode = "n";
        key = "<C-c>";
        action = "<cmd>bprevious<bar>bdelete #<cr>";
        options = {
          desc = "Close buffer without closing window";
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
          silent = true;
          desc = "Move down by display line";
        };
      }
      {
        mode = "n";
        key = "k";
        action = "gk";
        options = {
          silent = true;
          desc = "Move up by display line";
        };
      }
      # Disable native completion
      {
        mode = "i";
        key = "<C-n>";
        action = "<Nop>";
        options = {
          desc = "Disable native completion (use cmp instead)";
        };
      }
      {
        mode = "i";
        key = "<C-p>";
        action = "<Nop>";
        options = {
          desc = "Disable native completion (use cmp instead)";
        };
      }
      # Exit terminal mode <C-[>
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
        options = {
          desc = "Exit terminal mode";
        };
      }
    ];
  };
}
