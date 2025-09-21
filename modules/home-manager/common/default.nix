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



  # Shell configuration
  programs.bash = {
    enable = true;
    historySize = 10000;
    historyFileSize = 20000;
  };

  # Enable home-manager
  programs.home-manager.enable = true;
}
