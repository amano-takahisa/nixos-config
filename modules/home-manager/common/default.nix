{ config, ... }:

{
  # Common settings for all environments
  home = {
    username = "takahisa";
    homeDirectory = "/home/takahisa";
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Enable font configuration
  fonts.fontconfig.enable = true;

  # Enable XDG user directories
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # sops-nix configuration for user secrets
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets/user/takahisa.yaml;
    # Example secrets (uncomment and add to secrets/user/takahisa.yaml):
    # secrets.github_token = { };
    # secrets.openai_api_key = {
    #   path = "${config.home.homeDirectory}/.config/openai/api_key";
    # };
    secrets.example_user_secret = {
      path = "${config.home.homeDirectory}/.config/example/example_key";
    };
  };
}
