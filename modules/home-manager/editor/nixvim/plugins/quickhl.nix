{ pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-quickhl";
        src = pkgs.fetchFromGitHub {
          owner = "t9md";
          repo = "vim-quickhl";
          rev = "be1f44169c3fdee3beab629e83380515da03835e";
          hash = "sha256-8cVAdxfV+9tlYnuNL7uzx/dvYR2ZcgtIFSzwyPje/t4=";
        };
      })
    ];
    keymaps = [
      {
        mode = "n";
        key = "<leader>m";
        action = "<Plug>(quickhl-manual-this)";
        options = {
          desc = "Highlight word under cursor";
        };
      }
      {
        mode = "n";
        key = "<Esc><Esc><Esc>";
        action = "<Plug>(quickhl-manual-reset)";
        options = {
          desc = "Clear all highlights";
        };
      }
      {
        mode = "n";
        key = "<leader>n";
        action = "<Plug>(quickhl-manual-go-to-next)";
        options = {
          desc = "Go to next highlight";
        };
      }
      {
        mode = "n";
        key = "<leader>N";
        action = "<Plug>(quickhl-manual-go-to-prev)";
        options = {
          desc = "Go to previous highlight";
        };
      }
    ];
  };
}
