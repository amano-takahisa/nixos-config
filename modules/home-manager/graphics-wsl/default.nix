{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Image processing and editing
    imagemagick
    eog
  ];
}
