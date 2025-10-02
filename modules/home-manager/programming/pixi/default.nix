{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pixi
  ];
}

