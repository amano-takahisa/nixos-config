# WSL host configuration - Terminal-focused environment
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/packages/development.nix
    ../../modules/system/services/docker.nix
    ../../modules/system/ui/fonts.nix
    # Exclude ime.nix as requested - using Windows IME functionality
  ];

  # WSL-specific configuration
  wsl = {
    enable = true;
    defaultUser = "takahisa";
    startMenuLaunchers = true;

    # Enable integration features
    docker-desktop.enable = false; # Set to true if using Docker Desktop

    # WSL2 interoperability
    interop.includePath = false; # Don't add Windows PATH
  };

  networking.hostName = "wsl";

  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties
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

  # No X11 or desktop environment for WSL
  # services.xserver.enable = false;
  # services.displayManager.sddm.enable = false;
  # services.desktopManager.plasma6.enable = false;

  # No audio services for WSL (using Windows audio)
  # services.pulseaudio.enable = false;
  # services.pipewire.enable = false;

  # Enable fish shell
  programs.fish.enable = true;

  # Define a user account
  users.users.takahisa = {
    isNormalUser = true;
    description = "takahisa";
    extraGroups = [ "wheel" "docker" ]; # Remove networkmanager for WSL
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Minimal system packages for WSL
  environment.systemPackages = with pkgs; [
    # Essential WSL tools will be managed through home-manager
  ];

  # This value determines the NixOS release
  system.stateVersion = "25.05";

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
