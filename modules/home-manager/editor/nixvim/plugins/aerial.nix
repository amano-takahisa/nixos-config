{ ... }:

{
  programs.nixvim = {
    plugins.aerial = {
      enable = true;
      settings = {
        # set floating window position at top right
        float = {
          relative = "win";
          override = {
            __raw = ''
              function(conf, source_winid)
                -- This is the config that will be passed to nvim_open_win.
                -- Change values here to customize the layout
                local padding = 1
                conf.zindex = 25
                conf.anchor = "NE"
                conf.row = padding
                conf.col = vim.api.nvim_win_get_width(source_winid) - padding
                return conf
              end
            '';
          };
        };
      };
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

