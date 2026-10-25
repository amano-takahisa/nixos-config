[![Hippocratic License HL3-BDS-CL](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-BDS-CL&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/bds-cl.html)

# NixOS Multi-Host Configuration

Multi-host NixOS and macOS user configuration managed with Nix flakes and home-manager.

## Hosts

| Host     | Type                  | Desktop      | Notable Features                                 |
| -------- | --------------------- | ------------ | ------------------------------------------------ |
| msi      | Desktop               | KDE Plasma 6 | NVIDIA/CUDA, Waydroid, Podman, Geospatial tools  |
| sx2      | Desktop               | KDE Plasma 6 | Lightweight desktop                              |
| wsl      | WSL2                  | None         | Terminal-focused                                 |
| chie-mac | macOS (Apple Silicon) | SSH          | Standalone Home Manager for takahisa; shared Mac |

## Quick Start

### User environment (no sudo)

Rebuilds only user environment via home-manager. Defaults to `$USER@$HOSTNAME` and `switch`.

```bash
./home-rebuild.sh                    # current user@host, switch
./home-rebuild.sh takahisa@msi switch
```

### System-wide (requires sudo)

Full NixOS system rebuild. Defaults to `$HOSTNAME` and `switch`.

```bash
./rebuild.sh                         # current host, switch
./rebuild.sh msi switch
./rebuild.sh msi test                # test without making it the boot default
```

## Setup

### Shared MacBook Pro (chie-mac)

Chie's existing nix-darwin configuration manages the system and Nix daemon.
This repository manages only `/Users/takahisa` with standalone Home Manager;
it does not define a Darwin system configuration or require sudo for updates.
The macOS account and SSH access must already exist, and the Nix daemon must
permit this user to build packages. No `trusted-users` change is needed for
the normal workflow.

The Mac profile shares fish, tmux, Git, gh, ghq, lazygit, direnv, Atuin, search
tools, Codex, omp, agent instructions/skills, and the external Nixvim configuration
with the Linux profiles. Linux desktop modules, services, secret activation,
and omp's NixOS-specific browser instructions are not imported.

From an SSH session as `takahisa`, clone this repository and run:

```bash
git clone https://github.com/amano-takahisa/nixos-config.git
cd nixos-config
./home-rebuild.sh takahisa@chie-mac build
./home-rebuild.sh takahisa@chie-mac switch
```

Use the branch containing the Mac configuration until it is merged. New local
files must be added to Git before building a Git flake. Home Manager reports
conflicting existing dotfiles: review and move those files aside individually
before retrying; do not overwrite them blindly. Authenticate Codex, omp, and GitHub
as `takahisa` separately; credentials are not copied from Chie or stored here.

Reconnect with `ssh chie-mac`. Interactive SSH sessions enter fish through the
managed zsh configuration, without changing the account's registered login shell.
Noninteractive SSH commands, scp, and sftp retain zsh behavior. New tmux panes use
fish too. Confirm the tools are available:

```fish
type -a fish tmux codex omp nvim git gh ghq direnv rg fd
tmux new-session -s dev
```

For subsequent updates, pull the published changes and build on the Mac:

```bash
cd /path/to/nixos-config
git pull --ff-only
./home-rebuild.sh takahisa@chie-mac build
```

`build` creates the generation without activating it. When ready to apply it, run:

```bash
./home-rebuild.sh takahisa@chie-mac switch
```

On macOS the helper's default target is `takahisa@chie-mac` (using the current
`$USER`), so `./home-rebuild.sh` also applies updates. The helper uses
the Home Manager CLI pinned by this repository's lock file. Roll back a user
generation with `home-manager generations`, then execute the desired generation's
`activate` script. This does not roll back Chie's system configuration.

Each development project provides its own `flake.nix` and ML dependencies.
This repository's `nix develop` environment supports both `x86_64-linux` and
`aarch64-darwin` for configuration maintenance.

#### Verify PyTorch GPU access over SSH

Run this from the repository on the Mac, inside an SSH session. It obtains uv
from the pinned nixpkgs input and creates an isolated Python environment using
the PyTorch macOS wheel; PyTorch is not installed into the Home Manager profile:

```bash
nix shell --inputs-from . nixpkgs#uv -c uv run --no-project --isolated --python 3.12 --with torch scripts/check-mps.py
```

The check requires MPS to be built and available, executes matrix multiplication
and a backward pass on `mps`, synchronizes the GPU, and compares results with CPU
results. CPU fallback is disabled. A `PASS` confirms those operations in that
SSH session; it does not guarantee support for every model or operation. The
resolved PyTorch version is printed, and uv may retain downloaded packages in
its user cache. Project dependencies should be pinned separately.
See the [PyTorch MPS documentation](https://docs.pytorch.org/docs/stable/notes/mps.html).

tmux preserves sessions across SSH disconnections while the Mac is awake;
it does not prevent sleep or guarantee computation while the lid is closed.

### WSL2

Install NixOS on WSL2 following [NixOS-WSL](https://nix-community.github.io/NixOS-WSL/).

Add to `%USERPROFILE%\.wslconfig` on Windows:

```txt
[wsl2]
memory=16GB
swap=16GB
networkingMode=mirrored
```

Bootstrap the configuration:

```bash
nix-shell -p wget --run "wget https://github.com/amano-takahisa/nixos-config/archive/main.zip"
nix-shell -p unzip --run "unzip main.zip"
cd nixos-config-main
nix-shell -p git
./rebuild.sh wsl switch
```

After re-login, restore `~/.ssh` from backup and clone properly:

```bash
ghq get git@github.com:amano-takahisa/nixos-config.git
```

Then rebuild again from the cloned repository.

### Native NixOS

Use the NixOS installer and follow its guide.

#### Post-installation

1. Generate hardware configuration:

   ```bash
   sudo nixos-generate-config --dir hosts/HOST_NAME/
   ```

2. Update timezone/locale in `hosts/HOST_NAME/configuration.nix`.

3. Build and switch:

   ```bash
   ./rebuild.sh HOST_NAME switch
   ```

4. **Disable 5 GHz Wi-Fi** (if authentication fails repeatedly):

   ```bash
   nix-shell -p networkmanagerapplet --run nm-connection-editor
   ```

   Select Band B/G (2.4 GHz) for your Wi-Fi connection.

5. **Japanese input (Fcitx 5 / Mozc)**:
   - System Settings > Virtual keyboard > select "Fcitx 5"
     (see [Fcitx 5 on Wayland](https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#KDE_Plasma))
   - System Settings > Input Method > Add Input Method > search and add Mozc

6. **Caps Lock as Ctrl**:

   System Settings > Keyboard > Key Bindings > Configure keyboard options > Ctrl position > Caps Lock as Ctrl

7. **Login to services**:

   ```bash
   # GitHub CLI
   gh auth login -p ssh -h github.com -w
   ssh -T git@github.com

   # Neovim Copilot
   # :Copilot auth

   # Docker (rootless)
   systemctl --user enable --now docker
   docker run hello-world
   ```

8. **Clone repositories**:

   ```bash
   gh repo list "amano-takahisa" --limit 1000 --json sshUrl \
     | jq -r '.[].sshUrl' \
     | xargs -n1 ghq get --shallow
   ```

## Package Management

### nixpkgs

```bash
nix flake update
```

### llm-agents.nix

LLM agents (Claude Code, etc.) are provided by [llm-agents.nix](https://github.com/numtide/llm-agents.nix) with daily updates and pre-built binaries.

```bash
nix flake update llm-agents
```

### oh-my-pi (omp)

[oh-my-pi](https://github.com/can1357/oh-my-pi) (`omp`) is installed on the msi
host from nixpkgs (`pkgs.omp`) to use its binary cache when available, accepting
a potentially older version. The pinned `oh-my-pi` flake input provides only
the home-manager module (`modules/home-manager/misc/oh-my-pi/default.nix`).
Declarative settings go in `programs.omp.settings`.

```bash
nix flake update nixpkgs # Update the installed omp package
nix flake update oh-my-pi # Update only the settings module
```

### fetchFromGitHub packages

Hashes need to be updated manually when bumping a pinned `rev`/`version`. Two
patterns are used in this repo:

- **Tagged releases** — e.g. `gwq`
  (`modules/home-manager/vcs/gwq/default.nix`):
  - `version` is the upstream release version (e.g. `"0.1.1"`).
  - `rev` is derived from it: `rev = "v${version}"`.
  - `hash` is the sha256 of the GitHub source tarball at that `rev`.
  - `vendorHash` (Go modules only, via `buildGoModule`) is the sha256 of the
    vendored Go module dependencies. It changes independently of `hash`
    whenever upstream's `go.mod`/`go.sum` changes, so it must be bumped
    separately.

- **Rolling/unstable pins** — e.g. `mplus-outline-fonts-latest`
  (`modules/system/ui/fonts.nix`):
  - `rev` is a specific commit SHA (there's no release tag being tracked).
  - `version` is `"unstable-YYYY-MM-DD"`, set to the commit date of `rev`
    (not the date of the bump), so it's clear at a glance which upstream
    state is pinned.
  - There is no `vendorHash` since it's a plain `stdenvNoCC.mkDerivation`,
    not a Go build.

Don't trust `nix-prefetch-git`'s hash blindly: it hashes a plain `git clone`, while
`fetchFromGitHub` hashes a GitHub tarball, and the two don't always agree (they can
also just go stale between nixpkgs releases). Verify with a real build using the
`fakeHash` trick instead:

1. Bump `rev`/`version` in the package's `default.nix` (for a tagged release,
   bump `version` and let `rev` follow; for a rolling pin, bump `rev` to the
   new commit SHA and set `version` to that commit's date), and temporarily
   set `hash = pkgs.lib.fakeHash;` (also `vendorHash = pkgs.lib.fakeHash;` for
   `buildGoModule` packages like `gwq`).
2. Build it. Rebuilding the affected config works, e.g. `./home-rebuild.sh
takahisa@HOST_NAME switch` for a home-manager package like `gwq`, or
   `./rebuild.sh HOST_NAME switch` for a system module like `fonts.nix`.

   Or test the derivation in isolation, e.g. for `gwq`:

   ```bash
   nix-build --no-out-link -E '
   with import <nixpkgs> {};
   buildGoModule rec {
     pname = "gwq";
     version = "0.1.1";
     src = fetchFromGitHub {
       owner = "d-kuro";
       repo = "gwq";
       rev = "v${version}";
       hash = lib.fakeHash;
     };
     vendorHash = lib.fakeHash;
     doCheck = false;
   }
   '
   ```

3. Nix fails with `error: hash mismatch ... got: sha256-...` - copy that value into
   `hash`, then rebuild. If `vendorHash` also needs updating, the next build fails
   the same way for it; repeat once more.
4. Confirm the final build succeeds before committing.

## Secret Management (sops-nix)

Secrets are encrypted with [age](https://github.com/FiloSottile/age) via [sops-nix](https://github.com/Mic92/sops-nix). System secrets are decrypted using SSH host keys; user secrets use an age key file.

| Type   | Decryption Key                                 | Runtime Path                        |
| ------ | ---------------------------------------------- | ----------------------------------- |
| System | SSH host key (`/etc/ssh/ssh_host_ed25519_key`) | `/run/secrets/<name>`               |
| User   | Age key (`~/.config/sops/age/keys.txt`)        | `~/.config/sops-nix/secrets/<name>` |

### New Host Setup

1. Build the system to generate SSH host keys:

   ```bash
   ./rebuild.sh HOST_NAME switch
   ```

2. Get the host's age public key:

   ```bash
   nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'
   ```

3. Add the key to `.sops.yaml` under `keys` and uncomment the host anchor in `creation_rules`.

4. Re-encrypt secrets with the new key:

   ```bash
   nix-shell -p sops --run 'sops updatekeys secrets/example.yaml'
   nix-shell -p sops --run 'sops updatekeys secrets/user/takahisa.yaml'
   ```

5. Install the age secret key for editing:

   ```bash
   mkdir -p ~/.config/sops/age
   nvim ~/.config/sops/age/keys.txt   # paste AGE-SECRET-KEY-... from password manager
   chmod 600 ~/.config/sops/age/keys.txt
   ```

6. (Optional) Install system-level fallback key:

   ```bash
   sudo mkdir -p /var/lib/sops-nix
   sudo cp ~/.config/sops/age/keys.txt /var/lib/sops-nix/key.txt
   sudo chmod 600 /var/lib/sops-nix/key.txt
   ```

### Restore after Reinstall

```bash
# Restore SSH host key
sudo install -m600 -o root -g root /path/to/backup/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
sudo install -m644 -o root -g root /path/to/backup/ssh_host_ed25519_key.pub /etc/ssh/ssh_host_ed25519_key.pub

# Restore age user key
install -m600 -D /path/to/backup/age-key.txt ~/.config/sops/age/keys.txt

# (Optional) Restore system fallback age key
sudo install -m600 -D /path/to/backup/age-key.txt /var/lib/sops-nix/key.txt

# Rebuild
./rebuild.sh HOST_NAME switch
./home-rebuild.sh takahisa@HOST_NAME switch
```

Test that `nixos-rebuild` and `sops` work after restoration.

### Editing Secrets

```bash
# Edit system secrets
nix-shell -p sops --run 'sops secrets/example.yaml'

# Edit user secrets
nix-shell -p sops --run 'sops secrets/user/takahisa.yaml'

# Create and encrypt a new secret file
echo 'my_secret: "secret-value"' > secrets/new-secret.yaml
nix-shell -p sops --run 'sops --encrypt --in-place secrets/new-secret.yaml'
```

Add system secrets in `modules/system/sops/default.nix`:

```nix
{
  sops.defaultSopsFile = ../../../secrets/example.yaml;
  sops.secrets.my_secret = { };
  sops.secrets.db_password = {
    owner = "postgres";
    mode = "0400";
  };
}
```

### User Secrets (Home-Manager)

Add user secrets in `modules/home-manager/common/default.nix`:

```nix
{
  sops.secrets.my_secret = { };
  sops.secrets.api_key = {
    path = "${config.home.homeDirectory}/.config/myapp/api_key";
  };
}
```

Verify after rebuild:

```bash
./home-rebuild.sh takahisa@HOST_NAME switch
ls -la ~/.config/sops-nix/secrets/
systemctl --user status sops-nix.service
```

## Waydroid (Android Container)

Android container for msi host. Supports location services (geoclue2), clipboard sharing (wl-clipboard), and ARM translation for x86_64.

### Setup

Initialize with Google Apps:

```bash
sudo waydroid init -s GAPPS -f
```

Install ARM translation layer for ARM apps (e.g. Kindle) on x86_64:

```bash
git clone https://github.com/casualsnek/waydroid_script
cd waydroid_script
python3 -m venv venv
venv/bin/pip install -r requirements.txt
sudo venv/bin/python3 main.py
```

Verify ARM support:

```bash
sudo waydroid shell getprop ro.product.cpu.abilist
# Expected: x86_64,x86,arm64-v8a,armeabi-v7a,armeabi
```

For Google Play certification errors, see [FAQ](https://docs.waydro.id/faq/google-play-certification):

```bash
sudo waydroid shell -- sh -c "sqlite3 /data/data/*/*/gservices.db 'select * from main where name = \"android_id\";'"
```

Register the ID at <https://www.google.com/android/uncertified>, then restart:

```bash
waydroid session stop
```

### Usage

```bash
# Start
sudo systemctl start waydroid-container
waydroid session start
waydroid show-full-ui

# Launch a specific app
waydroid app launch <package-name>

# List / install apps
waydroid app list
waydroid app install /path/to/app.apk

# Stop
waydroid session stop
sudo systemctl stop waydroid-container

# Enable autostart
sudo systemctl enable waydroid-container
```

### Upgrading

```bash
sudo waydroid upgrade        # upgrade system images
sudo waydroid upgrade -o     # force reinstall
```

### Troubleshooting

```bash
# Check status
sudo systemctl status waydroid-container
waydroid status

# View logs
waydroid log
sudo journalctl -u waydroid-container

# Full reset (removes all data)
waydroid session stop
sudo systemctl stop waydroid-container
sudo rm -rf /var/lib/waydroid /home/.waydroid ~/waydroid
sudo waydroid init -s GAPPS -f
```

## OpenVPN (msi)

OpenVPN client for msi host. DNS is automatically updated on connect/disconnect via `updateResolvConf`.

### Setup

Place your `.ovpn` file:

```bash
sudo cp your-client.ovpn /etc/openvpn/client.ovpn
sudo chmod 600 /etc/openvpn/client.ovpn
```

### Usage

```bash
# Start
sudo systemctl start openvpn-client

# Stop
sudo systemctl stop openvpn-client

# Check status / logs
sudo systemctl status openvpn-client
sudo journalctl -u openvpn-client
```

## TODO

- <https://github.com/rickhowe/spotdiff.vim>
