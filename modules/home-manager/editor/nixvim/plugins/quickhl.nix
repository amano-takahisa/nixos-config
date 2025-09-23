{ pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-quickhl";
        src = pkgs.fetchFromGitHub {
          owner = "t9md";
          repo = "vim-quickhl";
          rev = "be1f44169c3fdee3beab629e83380515da03835e";
          hash = "sha256-8cVAdxfV+9tlYnuNL7uzx/dvYR2ZcgtIFSzwyPje/t4=";
        };
      })
    ];
  };
}