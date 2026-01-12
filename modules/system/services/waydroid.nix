{ pkgs, ... }:

{
  # Enable Waydroid - Android container for Wayland
  virtualisation.waydroid.enable = true;

  # Enable location services for Waydroid
  services.geoclue2.enable = true;

  # Add clipboard sharing support, ARM translation helper, and ADB tools
  environment.systemPackages = with pkgs; [
    wl-clipboard
    waydroid-helper # GUI/TUI for installing ARM translation (libhoudini/libndk)
    android-tools # Provides adb command (systemd 258+ handles uaccess rules automatically)
  ];

  # Enable waydroid-helper systemd service for ARM translation support
  systemd = {
    packages = [ pkgs.waydroid-helper ];
    services.waydroid-mount.wantedBy = [ "multi-user.target" ];
  };

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
