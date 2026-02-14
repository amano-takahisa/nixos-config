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
      # gitstats = "fzf --preview 'git -C {} status -s && echo ----- && git -C {} lo -n 5 --oneline' --bind 'enter:execute(cd {} && $SHELL)+reload(ghq list -p)'";


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

      # https://fishshell.com/docs/current/cmds/fish_git_prompt.html
      set -g __fish_git_prompt_char_stateseparator ' '
      set -g __fish_git_prompt_showdirtystate 1
      set -g __fish_git_prompt_showuntrackedfiles 1
      set -g __fish_git_prompt_showupstreamHEAD 1
      set -g __fish_git_prompt_show_informative_status 1
      set -g __fish_git_prompt_char_cleanstate '_'
      set -g __fish_git_prompt_char_dirtystate '*'
      set -g __fish_git_prompt_char_invalidstate '#'
      set -g __fish_git_prompt_char_stagedstate '+'
      set -g __fish_git_prompt_char_stashstate '$'
      set -g __fish_git_prompt_char_untrackedfiles '?'
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
