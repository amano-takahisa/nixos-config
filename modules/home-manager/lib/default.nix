{ lib, ... }:

{
  # Helper function to auto-import subdirectories that contain default.nix
  importSubdirectoriesWithDefault = currentDir:
    let
      # Read the specified directory
      dirContents = builtins.readDir currentDir;
      # Filter for directories only
      subdirectories = lib.filterAttrs (name: type: type == "directory") dirContents;
      # Check if each subdirectory has default.nix and import it
      validSubdirs = lib.filterAttrs (name: type:
        builtins.pathExists (currentDir + "/${name}/default.nix")
      ) subdirectories;
    in
    map (name: currentDir + "/${name}") (builtins.attrNames validSubdirs);
}