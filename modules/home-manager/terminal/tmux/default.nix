{ pkgs, ... }:

let
  # Keep host identification visible while full-screen applications are running.
  theme =
    if pkgs.stdenv.hostPlatform.isDarwin then {
      background = "#3b2616";
      border = "#a66328";
      accent = "#ffb454";
      label = "chie-mac";
    } else {
      background = "#182a3a";
      border = "#365b7a";
      accent = "#82aaff";
      label = "#h";
    };
in

{
  # tmux
  programs.tmux = {
    enable = true;
    shortcut = "a";
    mouse = true;
    keyMode = "vi";
    extraConfig = ''
      # Keep current working directory when open new window or panes
      bind-key c new-window -c "#{pane_current_path}"
      bind-key % split-window -hc "#{pane_current_path}"
      bind-key '"' split-window -vc "#{pane_current_path}"

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
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # Use Alt-arrow keys without prefix key to switch panes
      # disabled. conflict with oh-my-pi. Use hjkl or arrow keys with prefix.
      # bind-key -n M-Left select-pane -L
      # bind-key -n M-Right select-pane -R
      # bind-key -n M-Up select-pane -U
      # bind-key -n M-Down select-pane -D

      # Change pane border colors
      set-option -g pane-border-style "fg=${theme.border}"
      set-option -g pane-active-border-style "fg=${theme.accent}"

      # Keep showing window numbe when <prefix> q
      bind-key -T prefix e display-panes -d 0

      # keep pane title static
      set-option -g automatic-rename off
      set-option -g pane-border-format "#{pane_index}:#T"
      set-option -g status-interval 5
      set-option -g pane-border-status bottom

      # Disable layout change with <space>
      unbind-key Space

      #################
      # Status Bar
      #################
      # Set status bar position
      set-option -g renumber-windows on
      set-option -g status-bg "${theme.background}"
      set-option -g status-fg "${theme.accent}"
      set-option -g status-left-length 40
      set-option -g status-left "#[bold] ${theme.label} #[nobold]#S "
      set-option -g status-justify centre
      set-option -g status-position top
      set-window-option -g window-status-current-style "bg=${theme.accent},fg=${theme.background},bold"

      #################
      # Mouse
      #################
      # Reduce mouse wheel scroll amount (tmux default is 5 lines per notch)
      bind-key -T copy-mode-vi WheelUpPane   send-keys -X -N 2 scroll-up
      bind-key -T copy-mode-vi WheelDownPane send-keys -X -N 2 scroll-down

      #################
      # Others
      #################
      # Required for Kitty image protocol (image.nvim) to work through tmux
      set -g allow-passthrough on

      # start window/pane index from 1
      set -g base-index 1
      setw -g pane-base-index 1
      # send 'control + a' to applications
      bind-key C-a send-prefix
    '';


    # plugins = with pkgs; [
    #   tmuxPlugins.better-mouse-mode
    # ];
  };
}
