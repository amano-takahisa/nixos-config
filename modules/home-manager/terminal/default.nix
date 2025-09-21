{ pkgs, ... }:

{
  imports = [
    ./wezterm
  ];

  # Enable font configuration
  fonts.fontconfig.enable = true;
}