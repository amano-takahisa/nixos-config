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
sudo -E nixos-rebuild $OPERATION --flake .#$HOST --impure

echo "Build complete!"
