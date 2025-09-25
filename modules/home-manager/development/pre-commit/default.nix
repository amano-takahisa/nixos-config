{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pre-commit
    nixpkgs-fmt
  ];
}
