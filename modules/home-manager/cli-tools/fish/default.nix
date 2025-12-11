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
      # Add fish builtin completions to the completion path
      set -l builtin_completions $__fish_data_dir/completions
      if not contains $builtin_completions $fish_complete_path
        set -gx fish_complete_path $builtin_completions $fish_complete_path
      end

      # pixi completion
      pixi completion --shell fish | source

      set -g fish_prompt_pwd_dir_length 3
      set -g fish_prompt_pwd_full_dirs 3
      source ${./fish_prompt.fish}
      function fish_title
        set -q argv[1]; or set argv fish
        echo $argv: (prompt_pwd);
      end
      function we
        if test -f /proc/version && string match -qi "*microsoft*" (cat /proc/version)
          /mnt/c/Windows/explorer.exe (wslpath -w "$PWD")
        else
          echo "Error: 'we' command is only available on WSL (Windows Subsystem for Linux)"
          return 1
        end
      end
    '';
  };
}
