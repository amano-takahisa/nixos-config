{ pkgs, lib, ... }:

let
  libUtils = import ../../../lib { inherit lib; };
in
{
  # Import neovim and nixvim configurations, but exclude kate (GUI editor)
  imports = [
    ../editor/neovim
    ./nixvim # This will be a symlink to ../editor/nixvim
  ];
}
