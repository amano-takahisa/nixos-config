# MSI hardware configuration template
# This is a template - run 'nixos-generate-config' to create actual hardware config
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Boot configuration (example - adjust for your hardware)
  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ]; # or "kvm-amd" for AMD
  boot.extraModulePackages = [ ];

  # Filesystem configuration (example)
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b0d9164c-9af1-4785-95cd-a25028a5defd";
      fsType = "ext4";
    };

  # Swap configuration
  swapDevices =
    [ { device = "/dev/disk/by-uuid/fca925fa-ebe3-41d7-bb8b-02371efe9a28"; }
    ];
  # Hardware settings
  # hardware.cpu.intel.updateMicrocode = true; # or hardware.cpu.amd.updateMicrocode

  # Network interface
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
