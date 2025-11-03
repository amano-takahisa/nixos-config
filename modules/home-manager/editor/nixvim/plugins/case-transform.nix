{ lib, pkgs, ... }:

let
  caseTransformPath = /home/takahisa/ghq/personal/github.com/amano-takahisa/case-transform.nvim;
  caseTransformExists = builtins.pathExists caseTransformPath;
in
{
  warnings = lib.optional (!caseTransformExists)
    "zk_notebooks not found. Please run: ghq get git@github.com:amano-takahisa/zk_notebooks.git";

  programs.nixvim = lib.mkIf caseTransformExists {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "case-transform.nvim";
        version = "dev";
        src = caseTransformPath;
        postPatch = "rm -rf doc";
        meta.homepage = "https://github.com/amano-takahisa/case-transform.nvim";
      })
    ];

    extraConfigLua = ''
      require('case-transform').setup({ default_keymaps = true })
    '';
  };
}
