# Nix configuration and binary cache settings
# This module centralizes Nix daemon configuration including:
# - Binary cache substituters for faster rebuilds
# - Build optimization settings for parallelization
# - Flakes and experimental features
{ config, pkgs, ... }:

{
  nix.settings = {
    # Enable flakes and new nix command
    experimental-features = [ "nix-command" "flakes" ];

    # Trusted users for nix daemon
    trusted-users = [ "root" "takahisa" ];

    # Binary cache substituters
    # These pre-built binary caches significantly reduce rebuild times
    substituters = [
      "https://cache.nixos.org" # Official NixOS cache
      "https://nix-community.cachix.org" # Community packages (nixvim, plasma-manager, home-manager)
      "https://cuda-maintainers.cachix.org" # CUDA-enabled packages (critical for GPU computing)
      "https://numtide.cachix.org" # Development tools (devenv, treefmt)
    ];

    # Public keys for verifying cached packages
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    ];

    # Build optimization settings
    max-jobs = "auto"; # Automatically determine based on CPU cores (typically cores - 1)
    cores = 0; # Use all available cores per build job

    # Network optimization
    http-connections = 128; # Enable parallel downloads from multiple caches

    # Fallback behavior
    fallback = true; # Build from source if binary cache fetch fails

    # Logging
    keep-build-log = true; # Keep build logs for debugging

    # Reduce warnings for git-tracked flakes
    warn-dirty = false;
  };
}
