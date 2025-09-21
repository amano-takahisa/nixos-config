{ ... }:

{
  programs.nixvim = {
    plugins.aerial = {
      enable = true;
    };
    keymaps = [
    {
      mode = "n";
      key = "<leader>a";
      action = ":AerialToggle! float<CR>";
      options = {
        silent = true;
        desc = "Toggle Aerial";
      };
    }
    {
      mode = "n";
      key = "<leader>an" ;
      action = ":AerialNavToggle<CR>";
      options = {
        silent = true;
        desc = "Toggle Aerial Navigation";
      };
    }
    ];
  };
}

