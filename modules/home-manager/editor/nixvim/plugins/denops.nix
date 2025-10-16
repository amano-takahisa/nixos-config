{ pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "denops.vim";
        src = pkgs.fetchFromGitHub {
          owner = "vim-denops";
          repo = "denops.vim";
          rev = "a278b8342459e4687f24d4d575d72ff593326cee";
          hash = "sha256-JIRV9xfOqX6GLqBAeYqOePqaFWSyAr157958hBxmP8w=";
        };
      })
    ];
  };
}


