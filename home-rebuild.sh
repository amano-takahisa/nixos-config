#!/usr/bin/env bash

set -e

# Home Manager rebuild script with unfree packages enabled
# Usage: ./home-rebuild.sh [user@host] [operation]
# Example: ./home-rebuild.sh takahisa@sx2 switch

USER_HOST=${1:-$USER@$HOSTNAME}
OPERATION=${2:-switch}

echo "Run: NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#home-manager -- $OPERATION --flake .#$USER_HOST --impure"

export NIXPKGS_ALLOW_UNFREE=1
NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#home-manager -- "$OPERATION" --flake .#"$USER_HOST" --impure

echo "Build complete!"
