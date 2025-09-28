{ pkgs, config, ... }:

let
  workGitConfig = "${config.home.homeDirectory}/.config/git/work.gitconfig";
in
{
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
      pushf = "push --force-with-lease --force-if-includes";
      root = "rev-parse --show-toplevel";
      sh = "show --color-words='[^[:space:]]'";
      st = "status --short --branch";
    };
    extraConfig = {
      commit = { verbose = "true"; };
      core = { commentChar = ";"; };
      grep = { linenumber = "true"; };
      init = { defaultBranch = "main"; };
      log = { date = "iso-local"; };
      merge = { commit = "false"; };
      pull = { rebase = "true"; };
      rebase = { autoStash = "true"; };

      # use different commit profiles based on the directory
      includeIf = {
        "gitdir:${config.home.homeDirectory}/ghq/work/".path = workGitConfig;
      };

      ghq = {
        root = "~/ghq/personal";
        "https://github.com/eodcgmbh" = { root = "~/ghq/work"; };
        "ssh://github.com/eodcgmbh" = { root = "~/ghq/work"; };
      };
    };
  };

  # Generate work git configuration file
  home.file."${workGitConfig}".text = ''
    [user]
        email = takahisa.amano@eodc.eu
        name = Taka
  '';
}
