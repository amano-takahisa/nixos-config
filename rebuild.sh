#!/usr/bin/env bash

set -e

# NixOS rebuild script with unfree packages enabled
# Usage: ./rebuild.sh [host] [operation]
# Example: ./rebuild.sh sx2 switch

# HOST=${1:-sx2}
HOST=${1:-$HOSTNAME}
OPERATION=${2:-switch}

echo "Run: sudo nixos-rebuild $OPERATION --flake .#$HOST --impure"

export NIXPKGS_ALLOW_UNFREE=1

# to resolve memory issues during build wsl
# if hostname is 'wsl', limit the number of parallel jobs
if [ "$HOST" == "wsl" ]; then
  export NIX_MAX_JOBS=2
  export NIX_BUILD_CORES=2
  export CARGO_BUILD_JOBS=2
fi

sudo -E nixos-rebuild "$OPERATION" --flake .#"$HOST" --impure

echo "Build complete!"
