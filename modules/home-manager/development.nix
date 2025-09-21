{ pkgs, ...}:

{
  home.packages = with pkgs; [
    # python3
    ripgrep
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Taka";
    userEmail = "amano.takahisa@gmail.com";
    aliases = {
      aliases = "config --get-regexp '^alias\\.'";
      bl = "blame --abbrev=6";
      lo = "log --graph --all --date=format:'%Y-%m-%d %H:%M' --format='%C(white dim) %h %Creset %s %C(cyan dim)(%ad)%Creset%C(green) <%an>%C(bold yellow)%d%Creset'";
      loo = "log --stat --graph --decorate --all";
      root = "rev-parse --show-toplevel";
      sh = "show --color-words='[^[:space:]]'";
      st = "status --short --branch";
      pushf = "push --force-with-lease --force-if-includes";
    };
    extraConfig = {
      commit = {verbose = "true"; };
      pull = { rebase = "true"; };
      rebase = { autoStash = "true"; };
      merge = { commit = "false"; };
      grep = { linenumber = "true"; };
      log = { date = "iso-local"; };
      core = { commentChar = ";"; };
      init = { defaultBranch = "main"; };
    };
  };

}
