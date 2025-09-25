{ pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      -- Your lua code / config here
        return {
          font_size = 10.0,
          hide_tab_bar_if_only_one_tab = true,
          window_frame = {
            font_size = 9.0,
          },
        }
    '';
  };
}

