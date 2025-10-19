{ pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-gin";
        src = pkgs.fetchFromGitHub {
          owner = "lambdalisue";
          repo = "vim-gin";
          rev = "353e32d6e37228c0f51a6cf72c06210bb1340af9";
          hash = "sha256-zlNdfm+oUwcvzExFvtTqnHnwE8uqdOlxeUOGmVOBwIg=";
        };
      })
    ];

    extraConfigVim = ''
      source ${./plugins-extra/gin-preview.vim}
    '';
  };
}

