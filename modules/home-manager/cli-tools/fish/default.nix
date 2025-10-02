{ ... }:

{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      # File operations with eza
      l = "eza --long --classify --all --time-style=long-iso --group-directories-first";
      ll = "eza --long --classify --all --time-style=long-iso --group-directories-first";
      llt = "eza --long --classify --all --time-style=long-iso --group-directories-first --sort=changed";
      treee = "eza --tree --classify=auto";
      treel = "eza --tree --classify=auto --long";

      # Safe file operations
      rm = "rm -I";

      # Directory navigation
      ".." = "cd ..";
    };
    interactiveShellInit = ''
      set -g fish_prompt_pwd_dir_length 2
      set -g fish_prompt_pwd_full_dirs 3
      source ${./fish_prompt.fish}
    '';
  };
}
