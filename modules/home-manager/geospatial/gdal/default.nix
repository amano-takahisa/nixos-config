{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gdal
  ];
}
