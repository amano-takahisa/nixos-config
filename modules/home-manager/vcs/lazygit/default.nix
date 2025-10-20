{ pkgs, ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      git.paging.pager = "delta --dark --paging=never";
    };
  };
}

