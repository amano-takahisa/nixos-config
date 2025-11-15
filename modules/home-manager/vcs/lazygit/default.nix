{ pkgs, ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      git.pagers = [
        { pager = "delta --dark --paging=never"; }
      ];
    };
  };
}

