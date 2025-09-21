{ pkgs, ... }:

{
  imports = [
    ./tmux
    ./wezterm
  ];

  # Enable font configuration
  fonts.fontconfig.enable = true;
}