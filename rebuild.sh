#!/usr/bin/env bash

set -e

# NixOS rebuild script with unfree packages enabled
# Usage: ./rebuild.sh [host] [operation]
# Example: ./rebuild.sh sx2 switch

HOST=${1:-sx2}
OPERATION=${2:-switch}

echo "Building NixOS configuration for host: $HOST with operation: $OPERATION"

export NIXPKGS_ALLOW_UNFREE=1
sudo -E nixos-rebuild $OPERATION --flake .#$HOST --impure

echo "Build complete!"
