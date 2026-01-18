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

Add following to `%USERPROFILE%\.wslconfig` on Windows.

```txt
[wsl2]
memory=16GB
swap=16GB
networkingMode=mirrored
```

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

## Waydroid (Android Container)

Waydroid is configured for MSI host to run Android applications on NixOS using Wayland.

### Initial Setup

After rebuilding the system configuration, initialize Waydroid:

**With Google Apps (Play Store, Gmail, etc.):**

```bash
sudo waydroid init -s GAPPS -f
```

To run ARM-based Android apps (like Kindle) on x86_64 systems, install the ARM translation layer after `waydroid init`:

https://omemoji.com/articles/kindle_on_linux#user-content-fnref-5

```
git clone https://github.com/casualsnek/waydroid_script
cd waydroid_script
python3 -m venv venv
venv/bin/pip install -r requirements.txt
sudo venv/bin/python3 main.py
```

Verify ARM support:

```bash
sudo waydroid shell getprop ro.product.cpu.abilist
```

Expected output: `x86_64,x86,arm64-v8a,armeabi-v7a,armeabi`

If you have an error message about Google Play Certification,
follow [FAQ Google Play Certification](https://docs.waydro.id/faq/google-play-certification).

```bash
sudo waydroid shell -- sh -c "sqlite3 /data/data/*/*/gservices.db 'select * from main where name = \"android_id\";'"
```

and access to (https://www.google.com/android/uncertified)

and restart waydroid with

```bash
waydroid session stop
```

### Starting Waydroid

**1. Start the container:**

```bash
sudo systemctl start waydroid-container
```

**2. Start a user session:**

```bash
waydroid session start
```

**3. Launch the Android UI:**

```bash
waydroid show-full-ui
```

### Useful Commands

**Launch a specific app:**

```bash
waydroid app launch <package-name>
# Example: waydroid app launch com.android.settings
```

**List installed apps:**

```bash
waydroid app list
```

**Install an APK:**

```bash
waydroid app install /path/to/app.apk
```

**Stop Waydroid:**

```bash
waydroid session stop
sudo systemctl stop waydroid-container
```

**Enable autostart on boot:**

```bash
sudo systemctl enable waydroid-container
```

### Upgrading Waydroid

**Upgrade Android system images:**

```bash
sudo waydroid upgrade
```

**Force reinstall/upgrade:**

```bash
sudo waydroid upgrade -o
```

### Troubleshooting

**Check container status:**

```bash
sudo systemctl status waydroid-container
waydroid status
```

**View logs:**

```bash
waydroid log
# Or system logs:
sudo journalctl -u waydroid-container
```

**Reset Waydroid (removes all data):**

```bash
waydroid session stop
sudo systemctl stop waydroid-container
sudo rm -rf /var/lib/waydroid /home/.waydroid ~/waydroid
sudo waydroid init -s GAPPS -f  # Reinitialize
```

### Old commands

**1. Start the waydroid-monitor service:**

```bash
systemctl --user start waydroid-monitor
```

**2. Launch waydroid-helper:**

```bash
waydroid-helper
```

**3. In the GUI/TUI:**

- Navigate to **Extensions** → **Install ARM Translation**
- Select **libhoudini** (for Intel CPUs) or **libndk** (for AMD CPUs)
- Wait for installation to complete

**4. Restart Waydroid:**

```bash
sudo systemctl restart waydroid-container
waydroid session stop
waydroid show-full-ui
```

**Note:**

- The waydroid-monitor service needs to be started after each reboot
- Requires CPU with SSE4.2 support (Intel Core i3/i5/i7/i9 2008+, AMD Bulldozer 2011+/Ryzen)
- libhoudini is recommended for broader app compatibility

### Features

- **Location services**: Enabled via geoclue2 and adb
- **Clipboard sharing**: Supported via wl-clipboard
- **Wayland integration**: Native support for Plasma 6
- **ARM translation**: Support for ARM Android apps on x86_64 via waydroid-helper

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

### Packages from llm-agents.nix

LLM agents (Claude Code, etc.) are provided by [llm-agents.nix](https://github.com/numtide/llm-agents.nix).
Packages are automatically updated daily and pre-built binaries are available from Numtide's cache.

To update, simply run `nix flake update llm-agents`.

### Packages from pkgs.fetchFromGitHub

```bash
# nix-shell -p update-nix-fetchgit
# fd --type file '.nix$' --exec update-nix-fetchgit
nix-shell -p nix-prefetch-git --run 'nix-prefetch-git  https://github.com/lambdalisue/vim-gin.git'
```

Then, copy rev and hash to your nix file.

## TODO

- https://github.com/rickhowe/spotdiff.vim
