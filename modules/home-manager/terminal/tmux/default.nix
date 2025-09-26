{ ... }:

{
  # tmux
  programs.tmux = {
    enable = true;
    shortcut = "a";
    mouse = true;
    keyMode = "vi";
    extraConfig = ''
      # Keep current working directory when open new window or panes
      bind c new-window -c "#{pane_current_path}"
      bind % split-window -hc "#{pane_current_path}"
      bind '"' split-window -vc "#{pane_current_path}"

      #################
      # Neovim compatibility
      #################
      # Fix escape-time for Neovim
      set-option -sg escape-time 10

      # Enable focus-events for autoread
      set-option -g focus-events on

      # Set proper terminal for colors
      set-option -g default-terminal "screen-256color"

      # Enable true color support
      set-option -sa terminal-features ',xterm-256color:RGB'
      set-option -sa terminal-overrides ',xterm-256color:Tc'

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
      set-option -g pane-active-border-style "bg=#ffffa4,fg=#000000"

      # Keep showing window numbe when <prefix> q
      bind -T prefix e display-panes -d 0

      # keep pane title static
      set-option -g automatic-rename off
      set-option -g pane-border-format "#{pane_index}:#T #{pane_current_path}"
      set-option -g status-interval 5
      set-option -g pane-border-status bottom
    '';


    # plugins = with pkgs; [
    #   tmuxPlugins.better-mouse-mode
    # ];
  };
}
