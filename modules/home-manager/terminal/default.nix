{ lib, ... }:

let
  libUtils = import ../../../lib { inherit lib; };
in
{
  imports = libUtils.importSubdirectoriesWithDefault ./.;

  # Enable font configuration
  fonts.fontconfig.enable = true;
}
