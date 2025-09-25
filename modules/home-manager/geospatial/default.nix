{ pkgs, lib, ... }:

let
  libUtils = import ../../../lib { inherit lib; };
in
{
  imports = libUtils.importSubdirectoriesWithDefault ./.;
}

