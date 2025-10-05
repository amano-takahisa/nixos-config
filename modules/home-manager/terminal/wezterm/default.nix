{ pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      -- Your lua code / config here
        return {
          font = wezterm.font("HackGen Console NF"),
          font_size = 9.0,
          hide_tab_bar_if_only_one_tab = true,
          window_frame = {
            font_size = 8.0,
          },
          underline_position = "-0.13cell",
        }
    '';
  };
}

