{ pkgs, lib, ... }:

let
  # Helper function to import all .nix files in a directory
  importNixFiles = dir:
    let
      dirPath = ./. + "/${dir}";
      files = builtins.readDir dirPath;
      nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) files;
    in
    map (name: dirPath + "/${name}") (builtins.attrNames nixFiles);
in
{
  imports =
    # Import all config files
    (importNixFiles "config") ++
    # Import all plugin files
    (importNixFiles "plugins");

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # Colorscheme
    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "night";
        transparent = false;
        terminal_colors = true;
      };
    };
  };
}
