{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # packages for development, for all users
    bat
    clang
    gcc
    gnumake
    htop
    jq
    nodejs
    pkg-config
    tree
    tree-sitter
    wl-clipboard
  ];
}
