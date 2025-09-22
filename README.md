# NixOS Multi-Host Configuration

## Overview
This repository manages NixOS configurations for multiple environments using Nix flakes and home-manager.

## Host Configurations

### sx2 (Desktop - Full Featured)
- **Target**: Complete desktop environment  
- **Modules**: common, development, editor, gui
- **Includes**: All packages and applications

### msi (Desktop - Full Featured)
- **Target**: Complete desktop environment
- **Modules**: common, development, editor, graphics, office, gui
- **Includes**: All packages and applications

## Directory Structure

```
nixos-config/
├── flake.nix                    # Main flake configuration
├── rebuild.sh                   # Convenience script for system rebuilds
├── home-rebuild.sh              # Convenience script for home-manager rebuilds
├── hosts/
│   ├── sx2/
│   │   ├── configuration.nix    # sx2-specific system config
│   │   └── hardware-configuration.nix
│   └── msi/
│       ├── configuration.nix    # msi-specific system config
│       └── hardware-configuration.nix
└── modules/home-manager/
    ├── common.nix               # Base packages for all environments
    ├── development.nix          # Development tools (git, ripgrep, claude-code)
    ├── editor.nix               # Text editors and IDE tools
    ├── graphics.nix             # Graphics tools (GIMP, ImageMagick, etc.)
    ├── office.nix               # Office suite (LibreOffice, etc.)
    └── gui.nix                  # GUI applications
```

## Usage

### Applying changes to user environment (recommended for modules/home-manager/ changes):
```bash
./home-rebuild.sh takahisa@sx2 switch      # For sx2 host (recommended)
./home-rebuild.sh takahisa@msi switch      # For msi host (recommended)

# Alternative (manual approach):
NIXPKGS_ALLOW_UNFREE=1 nix shell nixpkgs#home-manager -c home-manager switch --flake .#takahisa@sx2 --impure   # For sx2 host
NIXPKGS_ALLOW_UNFREE=1 nix shell nixpkgs#home-manager -c home-manager switch --flake .#takahisa@msi --impure   # For msi host
```

### Applying system-wide changes:

```bash
./rebuild.sh sx2 switch      # For sx2 host (recommended)
./rebuild.sh msi switch      # For msi host (recommended)

# Alternative (manual approach):
export NIXPKGS_ALLOW_UNFREE=1
sudo -E nixos-rebuild switch --flake .#sx2 --impure
sudo -E nixos-rebuild switch --flake .#msi --impure
```

### Testing a configuration:
```bash
./rebuild.sh sx2 test        # Test without activation (recommended)

# Alternative (manual approach):
export NIXPKGS_ALLOW_UNFREE=1
sudo -E nixos-rebuild test --flake .#sx2 --impure
```

## Setup Instructions

### WSL2 Setup

Install NixOS on WSL2 by following the instructions at
https://nix-community.github.io/NixOS-WSL/

Clone this repository into your WSL2 instance

```bash
nix-shell -p git --run "git clone 
```

### New physical host setup

### Post OS installation steps

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

## Manual setups

Following configrations are not integrated nix-config yet.

### Disable 5GHz wifi

If your wi-fi authentication fails repeatedly, try disabling 5 GHz band.

```bash
nix-shell -p networkmanagerapplet
nm-connection-editor
```

Then, select Band B/G (2.4 GHz) for your wifi.

### Japanese environment

Go to "System Settings" -> "Virtual keyboard" and select "Fcitx 5" from it.
For more details see https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#KDE_Plasma 

Go to "System Settings" -> "Input Method" -> "Add Input Method",
then search Mozc, and add Mozc.

### Key bindings

"System Settings" -> "Keyboard" -> "Key Bindings"
Check "Configure keyboard options", and
- Ctrl position
    (x) Caps Lock as Ctrl 

### Login services

#### Firefox

#### claude code

```bash
claude
```

#### gh-cli

```bash
gh auth login -p ssh -h github.com -w
# test connection
ssh -T git@github.com
```

#### copilot.vim

```
:Copilot auth
```
### Docker

```bash
systemctl --user enable --now docker
# test docker
docker run hello-world
```


## Module Breakdown

- **common.nix**: Essential utilities and base system tools
- **development.nix**: Programming tools (git, ripgrep, claude-code)
- **editor.nix**: Text editors and IDE tools
- **graphics.nix**: Image processing (GIMP, ImageMagick, Inkscape)
- **office.nix**: Office applications (LibreOffice, Thunderbird)
- **gui.nix**: Desktop applications (Kate, Dolphin, VLC, Discord)

## Update Workflow

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

### Useful Aliases

For even faster home-manager rebuilds, you can add this alias to your shell:

```bash
alias hmr='./home-rebuild.sh'
```

Then use:
```bash
hmr takahisa@sx2 switch
hmr                     # Defaults to takahisa@sx2 switch
```

## User Information
- **Username**: takahisa (consistent across all hosts)
- **Host names**: sx2, msi
- **State version**: 25.05

## Rebuild Scripts

### System Rebuild Script (`rebuild.sh`)

The `rebuild.sh` script is provided to simplify system rebuilds with proper unfree package handling:

```bash
# Basic usage
./rebuild.sh [host] [operation]

# Examples
./rebuild.sh sx2 switch    # Rebuild and switch sx2 configuration
./rebuild.sh msi test      # Test msi configuration without switching
./rebuild.sh               # Defaults to: sx2 switch
```

### Home Manager Rebuild Script (`home-rebuild.sh`)

The `home-rebuild.sh` script simplifies home-manager rebuilds:

```bash
# Basic usage
./home-rebuild.sh [user@host] [operation]

# Examples
./home-rebuild.sh takahisa@sx2 switch    # Rebuild and switch user configuration
./home-rebuild.sh takahisa@msi test      # Test user configuration without switching
./home-rebuild.sh                        # Defaults to: takahisa@sx2 switch
```

**Why use the scripts?**
- Automatically sets `NIXPKGS_ALLOW_UNFREE=1` environment variable
- Uses `--impure` flag required for unfree packages (e.g., copilot.vim)
- Handles permissions correctly (`sudo` for system, no `sudo` for home-manager)
- Simpler than remembering the full command with flags

## Notes
- All configurations use home-manager for user-level package management
- Unfree packages are allowed in all configurations
- Flakes are enabled for all hosts
- **Important**: When using home-manager directly (not through nixos-rebuild), the `--impure` flag and `NIXPKGS_ALLOW_UNFREE=1` environment variable are required for unfree packages like copilot.vim
- **System rebuilds**: Always use `./rebuild.sh` instead of direct `nixos-rebuild` to ensure unfree packages work correctly
- **Home-manager rebuilds**: Always use `./home-rebuild.sh` instead of direct `home-manager` commands for consistent unfree package handling
