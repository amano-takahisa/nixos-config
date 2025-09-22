{ pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "chowcho.nvim";
        version = "2024-11-11";
        src = pkgs.fetchFromGitHub {
          owner = "tkmpypy";
          repo = "chowcho.nvim";
          rev = "c87ba3be2059070e16c89bf1710762dd70cb3007";
          hash = "sha256-8g4wgBmqCw9xfof3B3AHNca8FvTeYG1V74CIl2AfL7E=";
        };
      })
    ];

    extraConfigLua = ''
      require('chowcho').setup({
        exclude = function(buf, win)
          -- Exclude special windows like noice cmdline popup
          local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
          local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
          return buftype == 'nofile' and filetype == 'noice'
        end,
      })
    '';

    keymaps = [
      {
        mode = "n";
        key = "<C-w>e";
        action = "<cmd>Chowcho<cr>";
        options = {
          desc = "Select window with chowcho";
          silent = true;
        };
      }
    ];
  };
}
