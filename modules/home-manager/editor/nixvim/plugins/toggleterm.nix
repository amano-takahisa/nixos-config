{ ... }:

{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;
      settings = {
        direction = "float";
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<F4>";
        action = "<cmd>execute  v:count . \"ToggleTerm dir='%:p:h'\"<CR>";
        options = {
          desc = "Toggle Terminal";
        };
      }
    ];
  };
}

