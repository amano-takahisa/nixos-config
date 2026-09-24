{ ... }:

{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    # Atuin (sourced after fzf) owns Ctrl-R for fish history search.
    # Empty string = the supported way to yield Ctrl-R to the history manager;
    # silences the home-manager fzf/atuin Ctrl-R conflict warning.
    historyWidget.command = "";
  };
}

