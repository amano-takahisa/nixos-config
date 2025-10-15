{ ... }:

{
  programs.nixvim = {
    plugins.zen-mode = {
      enable = true;
    };
    keymaps = [
      {
        mode = "n";
        key = "<C-w>z";
        action = "<cmd>ZenMode<cr>";
        options = {
          silent = true;
          desc = "Toggle Zen Mode";
        };
      }
    ];
  };
}
