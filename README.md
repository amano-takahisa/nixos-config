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
NIXPKGS_ALLOW_UNFREE=1 nix shell nixpkgs#home-manager -c home-manager switch --flake .#takahisa@sx2 --impure   # For sx2 host
NIXPKGS_ALLOW_UNFREE=1 nix shell nixpkgs#home-manager -c home-manager switch --flake .#takahisa@msi --impure   # For msi host
```

### Applying system-wide changes:

```bash
sudo nixos-rebuild switch --flake .#sx2      # For sx2 host  
sudo nixos-rebuild switch --flake .#msi      # For msi host
```

### Testing a configuration:
```bash
sudo nixos-rebuild test --flake .#sx2        # Test without activation
```

### General rebuild (applies both system and user changes):
```bash
sudo nixos-rebuild switch                    # Uses default host configuration
```

## Setup Instructions

1. **Generate hardware configuration** for new hosts:
   ```bash
   sudo nixos-generate-config --dir hosts/HOST_NAME/
   ```

2. **Update timezone and locale** in each host's `configuration.nix`

3. **Adjust hardware-specific settings** in `hardware-configuration.nix`

4. **Build and switch** to your configuration:
   ```bash
   sudo nixos-rebuild switch --flake .#HOST_NAME
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
   NIXPKGS_ALLOW_UNFREE=1 nix shell nixpkgs#home-manager -c home-manager switch --flake .#takahisa@sx2 --impure
   ```
   - No `sudo` required
   - Only rebuilds user environment
   - Faster than full system rebuild
   - Uses temporary home-manager to avoid package conflicts
   - `--impure` and `NIXPKGS_ALLOW_UNFREE=1` needed for unfree packages (e.g., copilot.vim)

2. **Full system rebuild** (when system changes are needed):
   ```bash
   sudo nixos-rebuild switch --flake .#sx2
   ```
   - Requires `sudo`
   - Rebuilds entire system including user environment
   - Slower but comprehensive

### Useful Aliases

To simplify the long home-manager command, you can add this alias to your shell:

```bash
alias hm='NIXPKGS_ALLOW_UNFREE=1 nix shell nixpkgs#home-manager -c home-manager'
```

Then use:
```bash
hm switch --flake .#takahisa@sx2 --impure
```

## User Information
- **Username**: takahisa (consistent across all hosts)
- **Host names**: sx2, msi
- **State version**: 25.05

## Notes
- All configurations use home-manager for user-level package management
- Unfree packages are allowed in all configurations
- Flakes are enabled for all hosts
- **Important**: When using home-manager directly (not through nixos-rebuild), the `--impure` flag and `NIXPKGS_ALLOW_UNFREE=1` environment variable are required for unfree packages like copilot.vim
- WSL2 configuration includes Docker support
