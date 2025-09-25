# WSL hardware configuration - Minimal setup for WSL environment
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # WSL doesn't use traditional bootloaders
  boot.isContainer = true;

  # No hardware-specific configurations needed for WSL
  # WSL handles hardware abstraction

  # Network configuration is handled by WSL host
  networking.dhcpcd.enable = false;
  networking.useHostResolvConf = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}