#!/usr/bin/env bash

set -e

# Home Manager rebuild script with unfree packages enabled
# Usage: ./home-rebuild.sh [user@host] [operation]
# Example: ./home-rebuild.sh takahisa@sx2 switch

USER_HOST=${1:-takahisa@sx2}
OPERATION=${2:-switch}

echo "Building Home Manager configuration for user@host: $USER_HOST with operation: $OPERATION"

export NIXPKGS_ALLOW_UNFREE=1
NIXPKGS_ALLOW_UNFREE=1 nix shell nixpkgs#home-manager -c home-manager $OPERATION --flake .#$USER_HOST --impure

echo "Build complete!"
