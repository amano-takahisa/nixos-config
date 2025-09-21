{ ... }:

{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;
    };
    keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action = ":Telescope fd<CR>";
      options = {
        silent = true;
        desc = "Find files";
      };
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = ":Telescope live_grep<CR>";
      options = {
        silent = true;
        desc = "Live grep";
      };
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = ":Telescope buffers<CR>";
      options = {
        silent = true;
        desc = "Find buffers";
      };
    }
    ];
  };
}
