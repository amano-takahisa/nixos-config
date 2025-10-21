{ ... }:

{
  programs.nixvim = {
    plugins.web-devicons.enable = true;

    plugins.neo-tree = {
      enable = true;
      settings = {
        enable_git_status = false;
        filesystem = {
          filtered_items = {
            hide_dotfiles = false;
          };
          use_libuv_file_watcher = true;
        };
        default_component_configs.symlink_target.enabled = true;
        window = {
          width = 40;
          mappings = {
            "<space>" = "toggle_node";
            "<cr>" = "open";
            "<esc>" = "cancel";
            "l" = "open";
            "h" = "close_node";
            "S" = "open_split";
            "s" = "open_vsplit";
            "t" = "open_tabnew";
            "C" = "close_node";
            "z" = "close_all_nodes";
            "a" = "add";
            "A" = "add_directory";
            "d" = "delete";
            "r" = "rename";
            "y" = "copy_to_clipboard";
            "x" = "cut_to_clipboard";
            "p" = "paste_from_clipboard";
            "c" = "copy";
            "m" = "move";
            "q" = "close_window";
            "R" = "refresh";
            "?" = "show_help";
          };
        };
      };
    };
    extraConfigLuaPost = ''
      -- show git status only in ghq directories
      local function update_neotree_git_status()
        local cwd = vim.fn.getcwd()
        local ghq_path = vim.fn.expand("~/ghq")

        if cwd:match("^" .. vim.pesc(ghq_path)) then
          require("neo-tree").setup({
            enable_git_status = true
          })
        else
          require("neo-tree").setup({
            enable_git_status = false
          })
        end
      end

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
        action = ":Neotree focus %<CR>";
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
