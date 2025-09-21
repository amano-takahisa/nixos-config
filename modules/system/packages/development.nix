{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gcc
    clang
    gnumake
    pkg-config
  ];
}