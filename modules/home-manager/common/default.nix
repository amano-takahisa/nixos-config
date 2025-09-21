{ pkgs, ... }:

{
  # Common settings for all environments
  home = {
    username = "takahisa";
    homeDirectory = "/home/takahisa";

    # Basic packages for all environments
    packages = with pkgs; [
      # System utilities
      # curl
      # htop
      tree
      # unzip
      # wget
    ];
  };

  # tmux
  programs.tmux = {
    enable = true;
    shortcut = "a";
    mouse = true;
    keyMode = "vi";
    extraConfig = ''
      #################
      # Pains
      #################
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Use Alt-arrow keys without prefix key to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Change pane border colors
      set -g pane-active-border-style "bg=#ffffa4,fg=#000000"

      # Keep showing window numbe when <prefix> q
      bind -T prefix e display-panes -d 0

      # keep pane title static
      set -g automatic-rename off
      set -g pane-border-format "#{pane_index}:#T #{pane_current_path}"
      set -g status-interval 5
      set -g pane-border-status bottom
    '';


    # plugins = with pkgs; [
    #   tmuxPlugins.better-mouse-mode
    # ];
  };


  # Shell configuration
  programs.bash = {
    enable = true;
    historySize = 10000;
    historyFileSize = 20000;
  };

  # Enable home-manager
  programs.home-manager.enable = true;
}
