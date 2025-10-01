{ ... }:

{
  # Common settings for all environments
  home = {
    username = "takahisa";
    homeDirectory = "/home/takahisa";
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Enable XDG user directories
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
