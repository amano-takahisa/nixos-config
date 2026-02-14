# Common system settings shared across all hosts
{ pkgs, ... }:

{
  imports = [
    ../nix-gc.nix
    ../nix-settings.nix
    ../packages/development.nix
    ../services/docker.nix
    ../sops
    ../ui/fonts.nix
  ];

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Timezone
  time.timeZone = "Europe/Vienna";

  # Internationalisation
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable fish shell
  programs.fish.enable = true;

  # Default user account
  users.users.takahisa = {
    isNormalUser = true;
    description = "takahisa";
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
