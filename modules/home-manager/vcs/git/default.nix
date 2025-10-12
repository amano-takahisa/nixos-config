{ config, ... }:

{
  # Git configuration
  programs.git = {
    enable = true;
    userName = "Taka";
    userEmail = "amano.takahisa@gmail.com";
    includes = [
      {
        condition = "gitdir:${config.home.homeDirectory}/ghq/work/";
        contents.user.email = "takahisa.amano@eodc.eu";
        contents.user.name = "Taka";
      }
    ];
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

      ghq = {
        root = "~/ghq/personal";
        "https://github.com/eodcgmbh" = { root = "~/ghq/work"; };
        "ssh://github.com/eodcgmbh" = { root = "~/ghq/work"; };
        "https://git.eodc.eu" = { root = "~/ghq/work"; };
        "ssh://git.eodc.eu" = { root = "~/ghq/work"; };
      };
    };
    ignores = [
      "*_taka.ipynb"
      "*_taka.md"
      "*_taka.py"
      "*_taka.sh"
      "*_taka.txt"
      "*_taka/"
      ".back"
      ".worktree/"

      ### Python ###
      "__pycache__/"
      "*.py[codz]"
      "*$py.class"
      ### JupyterNotebooks ###
      # gitignore template for Jupyter Notebooks
      # website: http://jupyter.org/
      ".ipynb_checkpoints"
      "*/.ipynb_checkpoints/"
      ".virtual_documents/"

      # IPython
      "profile_default/"
      "ipython_config.py"
      "Untitled.ipynb"
      "Untitled*.ipynb"

      # AI coding assistants
      ".claude"
      ".serena"
    ];
  };
}
