#!/usr/bin/env bash

set -e

# Home Manager rebuild script with unfree packages enabled
# Usage: ./home-rebuild.sh [user@host] [operation]
# Example: ./home-rebuild.sh takahisa@sx2 switch

if [[ $(uname -s) == Darwin ]]; then
  DEFAULT_HOST=chie-mac
else
  DEFAULT_HOST=${HOSTNAME:-$(hostname)}
fi
USER_HOST=${1:-$USER@$DEFAULT_HOST}
OPERATION=${2:-switch}

echo "Run: NIXPKGS_ALLOW_UNFREE=1 nix run .#home-manager -- $OPERATION --flake .#$USER_HOST --impure"

export NIXPKGS_ALLOW_UNFREE=1
NIXPKGS_ALLOW_UNFREE=1 nix run .#home-manager -- "$OPERATION" --flake .#"$USER_HOST" --impure

echo "Build complete!"
