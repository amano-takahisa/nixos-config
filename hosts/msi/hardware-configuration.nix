# MSI hardware configuration template
# This is a template - run 'nixos-generate-config' to create actual hardware config
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Boot configuration (example - adjust for your hardware)
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ]; # or "kvm-amd" for AMD
  boot.extraModulePackages = [ ];

  # Filesystem configuration (example)
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-UUID";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-BOOT-UUID";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  # Swap configuration
  swapDevices = [
    { device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-SWAP-UUID"; }
  ];

  # Hardware settings
  hardware.cpu.intel.updateMicrocode = true; # or hardware.cpu.amd.updateMicrocode
  hardware.graphics.enable = true;

  # Network interface
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}