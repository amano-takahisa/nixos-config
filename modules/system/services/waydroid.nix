{ pkgs, ... }:

{
  # Enable Waydroid - Android container for Wayland
  virtualisation.waydroid.enable = true;

  # Enable location services for Waydroid
  services.geoclue2.enable = true;
  programs.adb.enable = true;

  # Add clipboard sharing support
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

  # Add user to adbusers group for location services
  users.users.takahisa.extraGroups = [ "adbusers" ];

  # Enable required kernel modules for Waydroid
  boot.kernelModules = [
    "binder_linux"
    "ashmem_linux"
  ];

  # Enable nftables support (required for waydroid-nftables)
  networking.nftables.enable = true;

  # Enable IP forwarding for Waydroid networking
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };
}
