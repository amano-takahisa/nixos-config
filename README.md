# Setup NixOS environment

# Basic Nix commands

Use packages temporally

```bash
nix-shell -p tmux neovim git
# if you need another package in the nix-shell,
# add packages with
# $ nix-shell -p git --run $SHELL
```

## Setup

Apply configurations in this repository to a newly setup NixOS host, follow steps below.

Update `configuration.nix` to enable Flakes features as follows:

```nix
# /etc/nixos/configuration.nix
{
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
```

Then, apply the setting:

```bash
sudo nixos-rebuild switch
```

```bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#sx2
```

## How this repository was initialized

```bash
git config --global init.defaultBranch main
git config --global user.email amano.takahisa@gmail.com
git config --global user.name Taka

mkdir -p ~/nixos-config
cd $_

sudo cp -r /etc/nixos/configuration.nix .
sudo chown takahisa configuration.nix

git add .
git commit -m 'init repo'

# after enable Flake
nix flake init

```
