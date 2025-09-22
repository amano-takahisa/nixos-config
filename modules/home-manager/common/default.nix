{ pkgs, ... }:

{
  # Common settings for all environments
  home = {
    username = "takahisa";
    homeDirectory = "/home/takahisa";

    # Basic packages for all environments
    packages = with pkgs; [
      # System utilities
      # curl
      # htop
      tree
      # unzip
      # wget
    ];
  };

  # Enable home-manager
  programs.home-manager.enable = true;
}
