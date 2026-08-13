{ pkgs, ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      git.diffRenderers = [
        { name = "delta"; command = "delta --dark --paging=never"; }
      ];
    };
  };
}

