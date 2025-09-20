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
      tmux
      # unzip
      # wget
    ];
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "takahisa";
    userEmail = "takahisa@example.com"; # Change this to your email
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
