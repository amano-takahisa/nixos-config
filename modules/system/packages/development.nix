{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    clang
    gcc
    gnumake
    nodejs
    pkg-config
    tree-sitter
    wl-clipboard
  ];
}
