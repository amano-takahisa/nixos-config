{ config, pkgs, ... }:

{
  # Explicit imports keep Linux services and desktop packages out of this home.
  imports = [
    ../../modules/home-manager/cli-tools/atuin
    ../../modules/home-manager/cli-tools/delta
    ../../modules/home-manager/cli-tools/direnv
    ../../modules/home-manager/cli-tools/eza
    ../../modules/home-manager/cli-tools/fd
    ../../modules/home-manager/cli-tools/fish
    ../../modules/home-manager/cli-tools/fzf
    ../../modules/home-manager/cli-tools/ripgrep
    ../../modules/home-manager/cli-tools/sd
    ../../modules/home-manager/cli-tools/zoxide
    ../../modules/home-manager/vcs/git
    ../../modules/home-manager/vcs/gh-cli
    ../../modules/home-manager/vcs/ghq
    ../../modules/home-manager/vcs/lazygit
    ../../modules/home-manager/terminal/tmux
    ../../modules/home-manager/misc/openai
    ../../modules/home-manager/misc/oh-my-pi
    ../../modules/home-manager/misc/agent-workflow
  ];

  home = {
    username = "takahisa";
    homeDirectory = "/Users/takahisa";
    stateVersion = "26.05";
    sessionPath = [ "${config.home.homeDirectory}/.nix-profile/bin" ];
    packages = with pkgs; [ curl jq gnumake gnused coreutils ];
  };
  programs.home-manager.enable = true;
  xdg.enable = true;

  # Keep macOS's registered login shell. Only interactive SSH sessions enter
  # fish; remote commands, scp, and sftp retain their usual behavior.
  programs.zsh = {
    enable = true;
    initContent = ''
      if [[ -n "$SSH_CONNECTION" ]]; then
        exec ${config.programs.fish.package}/bin/fish --login
      fi
    '';
  };
  programs.tmux.shell = "${config.programs.fish.package}/bin/fish";
}
