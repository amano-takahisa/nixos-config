{ ... }:

{
  programs.nixvim = {
    plugins.web-devicons.enable = true;

    plugins.neo-tree = {
      enable = true;
    };
    extraConfigLuaPost = ''
      local neotree_config = {
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
          },
          use_libuv_file_watcher = true,
        },
        default_component_configs = {
          symlink_target = {
            enabled = true,
          },
        },
      }

      -- show git status only in ghq directories
      local function update_neotree_git_status()
        local cwd = vim.fn.getcwd()
        local ghq_path = vim.fn.expand("~/ghq")
        local config = vim.deepcopy(neotree_config)
        config.enable_git_status = vim.startswith(cwd, ghq_path)
        require("neo-tree").setup(config)
      end

      -- Initial setup
      update_neotree_git_status()

      vim.api.nvim_create_autocmd("DirChanged", {
        pattern = "*",
        callback = update_neotree_git_status,
        desc = "Update neo-tree git status on directory change"
      })
    '';
    keymaps = [
      {
        mode = "n";
        key = "<C-n>";
        action = ":Neotree toggle<CR>";
        options = {
          silent = true;
          desc = "Toggle Neo-tree";
        };
      }
      {
        mode = "n";
        key = "<C-n>%";
        action = ":Neotree reveal<CR>";
        options = {
          silent = true;
          desc = "Toggle Neo-tree current file";
        };
      }
      {
        mode = "n";
        key = "<C-n>b";
        action = ":Neotree toggle show buffers right<CR>";
        options = {
          silent = true;
          desc = "Neo-tree Buffers";
        };
      }
    ];
  };
}
