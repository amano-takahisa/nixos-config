{ ... }:

{
  programs.nixvim = {
    plugins.web-devicons.enable = true;

    plugins.neo-tree = {
      # https://nix-community.github.io/nixvim/plugins/neo-tree/index.html
      enable = true;
      enableGitStatus = false;
      popupBorderStyle = "rounded";
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
      filesystem = {
        useLibuvFileWatcher = true;
      };
    };
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
