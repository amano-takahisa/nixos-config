{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # GUI applications
    # kate          # Text editor
    # dolphin       # File manager
    # konsole       # Terminal
    # spectacle     # Screenshot tool
    # gwenview      # Image viewer

    # Terminal
    wezterm

    # Media players
    vlc
    # mpv

    # Communication
    # discord
    # telegram-desktop

    # Utilities
    # kdePackages.kcalc
    # kdePackages.kcharselect
  ];

  # Enable font configuration
  fonts.fontconfig.enable = true;

}
