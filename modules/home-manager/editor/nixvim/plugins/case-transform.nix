{ pkgs, lib, ... }:

let
  caseTransformPath = /home/takahisa/ghq/personal/github.com/amano-takahisa/case-transform.nvim;
  caseTransformExists = builtins.pathExists caseTransformPath;
in
{
  warnings = lib.optional (!caseTransformExists)
    "case-transform.nvim not found. Please run: ghq get git@github.com:amano-takahisa/case-transform.nvim.git";

  programs.nixvim =
    if caseTransformExists then {
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
    } else { };
}
