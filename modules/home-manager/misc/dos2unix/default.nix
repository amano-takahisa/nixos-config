{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dos2unix
  ];
}

