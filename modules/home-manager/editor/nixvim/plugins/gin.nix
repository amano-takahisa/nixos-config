{ pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-gin";
        src = pkgs.fetchFromGitHub {
          owner = "lambdalisue";
          repo = "vim-gin";
          rev = "xxxxxxx";
          hash = "sha256-xxxxxxx=";
        };
      })
    ];
  };
}

