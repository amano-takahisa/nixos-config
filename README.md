# NixOS Multi-Host Configuration

## Overview
This repository manages NixOS configurations for multiple environments using Nix flakes and home-manager.

## Host Configurations

### sx2 (Desktop - Graphics Restricted)
- **Target**: Desktop environment without graphics tools
- **Modules**: common, development
- **Excludes**: graphics (GIMP, ImageMagick), office suite, GUI apps

### msi (Desktop - Full Featured)
- **Target**: Complete desktop environment
- **Modules**: common, development, graphics, office, gui
- **Includes**: All packages and applications

### wsl2 (WSL2 - CLI Focused)
- **Target**: Windows Subsystem for Linux environment
- **Modules**: common, development
- **Excludes**: GUI applications, desktop environment

## Directory Structure

```
nixos-config/
├── flake.nix                    # Main flake configuration
├── hosts/
│   ├── sx2/
│   │   ├── configuration.nix    # sx2-specific system config
│   │   └── hardware-configuration.nix
│   ├── msi/
│   │   ├── configuration.nix    # msi-specific system config
│   │   └── hardware-configuration.nix
│   └── wsl2/
│       ├── configuration.nix    # wsl2-specific system config
│       └── hardware-configuration.nix
└── modules/home-manager/
    ├── common.nix               # Base packages for all environments
    ├── development.nix          # Development tools
    ├── graphics.nix             # Graphics tools (GIMP, ImageMagick, etc.)
    ├── office.nix               # Office suite (LibreOffice, etc.)
    └── gui.nix                  # GUI applications
```

## Usage

### Building a specific host configuration:
```bash
sudo nixos-rebuild switch --flake .#sx2   # For sx2 host
sudo nixos-rebuild switch --flake .#msi   # For msi host
sudo nixos-rebuild switch --flake .#wsl2  # For wsl2 host
```

### Testing a configuration:
```bash
sudo nixos-rebuild test --flake .#sx2
```

### Building with home-manager only:
```bash
home-manager switch --flake .#takahisa@sx2
home-manager switch --flake .#takahisa@msi
home-manager switch --flake .#takahisa@wsl2
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

## Module Breakdown

- **common.nix**: Essential utilities (git, vim, htop, etc.)
- **development.nix**: Programming tools (Python, tmux, ripgrep)
- **graphics.nix**: Image processing (GIMP, ImageMagick, Inkscape)
- **office.nix**: Office applications (LibreOffice, Thunderbird)
- **gui.nix**: Desktop applications (Kate, Dolphin, VLC, Discord)

## User Information
- **Username**: takahisa (consistent across all hosts)
- **Host names**: sx2, msi, wsl2
- **State version**: 25.05

## Notes
- All configurations use home-manager for user-level package management
- Unfree packages are allowed in all configurations
- Flakes are enabled for all hosts
- WSL2 configuration includes Docker support
