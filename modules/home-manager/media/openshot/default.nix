{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # openshot-qt
    # #################
    # Since openshot-qt depends on qt5 which has security vulnerabilities,
    # instead of installing it directly, use it in a nix-shell by running:
    #
    # ```
    # nix run github:nixos/nixpkgs/b37576faa4efddb7a8e4394cb14821140bb6d1b2#openshot-qt
    # ```
    # #################
  ];
}

