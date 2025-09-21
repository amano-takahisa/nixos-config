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
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
        term_colors = true;
        integrations = {
          cmp = true;
          gitsigns = true;
          neo_tree = true;
          telescope = {
            enabled = true;
          };
          treesitter = true;
          which_key = true;
        };
      };
    };
  };
}
