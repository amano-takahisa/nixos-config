[![Hippocratic License HL3-BDS-CL](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-BDS-CL&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/bds-cl.html)

# NixOS Multi-Host Configuration

## Overview

This repository manages NixOS configurations for multiple environments using Nix flakes and home-manager.

## Usage

### Applying changes to user environment (recommended for modules/home-manager/ changes):

```bash
./home-rebuild.sh takahisa@sx2 switch      # For sx2 host
./home-rebuild.sh takahisa@msi switch      # For msi host
./home-rebuild.sh takahisa@wsl switch      # For wsl host
```

### Applying system-wide changes:

```bash
./rebuild.sh sx2 switch      # For sx2 host
./rebuild.sh msi switch      # For msi host
./rebuild.sh wsl switch      # For msi host
```

### Testing a configuration:

```bash
./rebuild.sh sx2 test        # Test without activation
```

## Setup Instructions

### WSL2

Install NixOS on WSL2 by following the instructions at
https://nix-community.github.io/NixOS-WSL/

Clone this repository into your WSL2 instance

```bash
nix-shell -p wget --run "wget https://github.com/amano-takahisa/nixos-config/archive/main.zip"
nix-shell -p unzip --run "unzip main.zip"
cd nixos-config-main
nix-shell -p git
./rebuild.sh wsl switch
```

Re-login to the NixOS, restore `~/.ssh` from backup, and

```
ghq get git@github.com:amano-takahisa/nixos-config.git
```

and rebuild again.

### Native NixOS installation

Use NixOS installer and follow installer's guide.

#### Post OS installation steps

1. **Generate hardware configuration** for new hosts:

   ```bash
   sudo nixos-generate-config --dir hosts/HOST_NAME/
   ```

2. **Update timezone and locale** in each host's `configuration.nix`

3. **Adjust hardware-specific settings** in `hardware-configuration.nix`

4. **Build and switch** to your configuration:
   ```bash
   ./rebuild.sh HOST_NAME switch
   ```

Following configrations are not integrated nix-config yet.

#### Disable 5GHz wifi

If your wi-fi authentication fails repeatedly, try disabling 5 GHz band.

```bash
nix-shell -p networkmanagerapplet --run nm-connection-editor
```

Then, select Band B/G (2.4 GHz) for your wifi.

#### Japanese environment

Go to "System Settings" -> "Virtual keyboard" and select "Fcitx 5" from it.
For more details see https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#KDE_Plasma

Go to "System Settings" -> "Input Method" -> "Add Input Method",
then search Mozc, and add Mozc.

#### Key bindings

"System Settings" -> "Keyboard" -> "Key Bindings"
Check "Configure keyboard options", and

- Ctrl position
  (x) Caps Lock as Ctrl

#### Login services

- Firefox
- Claude code
- gh-cli
  ```bash
  gh auth login -p ssh -h github.com -w
  # test connection
  ssh -T git@github.com
  ```
- Neovim Copilot
  ```
  :Copilot auth
  ```
- Docker
  ```bash
  systemctl --user enable --now docker
  # test docker
  docker run hello-world
  ```

#### Clone repositories

The following command clones all repositories from GitHub user "amano-takahisa"

```bash
gh repo list "amano-takahisa" --limit 1000 --json sshUrl \
  | jq -r '.[].sshUrl' \
  | xargs -n1 ghq get --shallow
```

## Rebuilding Instructions

When making changes to `modules/home-manager/` files:

1. **Fast user-only updates** (recommended):

   ```bash
   ./home-rebuild.sh takahisa@sx2 switch
   ```

   - No `sudo` required
   - Only rebuilds user environment
   - Faster than full system rebuild
   - Uses temporary home-manager to avoid package conflicts
   - Automatically handles unfree packages and impure flags

2. **Full system rebuild** (when system changes are needed):

   ```bash
   ./rebuild.sh sx2 switch
   ```

   - Requires `sudo` (handled by script)
   - Rebuilds entire system including user environment
   - Slower but comprehensive
   - Automatically handles unfree packages

## Upgrade packages

### Packages from nixpkgs

```bash
sudo nix-channel --update
nix flake update
```

### Node packages (node2nix)

```bash
cd tools/node2nix
nix-shell -p nodePackages.node2nix --run "node2nix -i node-packages.json -o node-packages.nix"
```

Then, run `./rebuild.sh` and `./home-rebuild.sh` to apply changes.

### Packages from pkgs.fetchFromGitHub

```bash
# nix-shell -p update-nix-fetchgit
# fd --type file '.nix$' --exec update-nix-fetchgit
nix-shell -p nix-prefetch-git --run 'nix-prefetch-git  https://github.com/lambdalisue/vim-gin.git'
```

Then, copy rev and hash to your nix file.

## node2nix

```bash
cd tools/node2nix
nix-shell -p nodePackages.node2nix
echo '["@github/copilot-language-server", "@anthropic-ai/claude-code", "sitemcp"]' \
  >> node-packages.json
node2nix -i node-packages.json
```

https://www.takeokunn.org/posts/fleeting/20250622133346-how_to_use_node2nix/

## TODO

- https://github.com/rickhowe/spotdiff.vim
