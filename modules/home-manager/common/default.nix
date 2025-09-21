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
      fish
    ];
  };



  # Shell configuration
  programs.fish = {
    enable = true;
  };

  # Enable home-manager
  programs.home-manager.enable = true;
}
