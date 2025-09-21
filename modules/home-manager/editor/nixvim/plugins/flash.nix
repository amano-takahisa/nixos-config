{ ... }:

{
  programs.nixvim = {
    plugins.flash = {
      enable = true;
    };
    keymaps = [
      {
        mode = "n";
        key = "s";
        action = "<cmd>lua require('flash').jump()<cr>";
        options = {
          desc = "Flash jump";
        };
      }
      {
        mode = "n";
        key = "S";
        action = "<cmd>lua require('flash').treesitter()<cr>";
        options = {
          desc = "Flash treesitter";
        };
      }
      {
        mode = "o";
        key = "r";
        action = "<cmd>lua require('flash').remote()<cr>";
        options = {
          desc = "Flash remote";
        };
      }
      {
        mode = "o";
        key = "R";
        action = "<cmd>lua require('flash').treesitter_search()<cr>";
        options = {
          desc = "Flash treesitter search";
        };
      }
      {
        mode = "x";
        key = "R";
        action = "<cmd>lua require('flash').treesitter_search()<cr>";
        options = {
          desc = "Flash treesitter search (visual)";
        };
      }
    ];
  };
}

