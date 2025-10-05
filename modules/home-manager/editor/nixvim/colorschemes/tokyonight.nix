{ ... }:

{
  programs.nixvim = {
    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "night"; # Options: storm, night, day, moon
        transparent = false;
        terminal_colors = false;
        on_highlights = ''
          -- TODO: Change highlight colors based on styles.
          --       Currently the followings are applied to all styles.
          function(highlights, colors)
            highlights.CursorColumn = { bg = "#1F2433" }
            highlights.CursorLine = { bg = "#1F2433" }
          end
        '';
      };
    };
  };
}


