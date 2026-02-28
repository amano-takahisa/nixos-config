# Nix garbage collection and generation management
{ config, pkgs, ... }:

{
  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Automatic Nix store optimization
  # Replaces duplicate files in the store with hard links to save disk space
  nix.optimise.automatic = true;

  # Prune old system generations during activation
  system.activationScripts.prune-old-generations.text = ''
    ${config.nix.package}/bin/nix-env --profile /nix/var/nix/profiles/system --delete-generations +10
  '';
}
