{ pkgs, ... }:

let
  caseTransformPath = /home/takahisa/ghq/personal/github.com/amano-takahisa/case-transform.nvim;
  caseTransformExists = builtins.pathExists caseTransformPath;
in
{
  programs.nixvim = {
    extraPlugins =
      if caseTransformExists then [
        (pkgs.vimUtils.buildVimPlugin {
          pname = "case-transform.nvim";
          version = "dev";
          src = caseTransformPath;
          postPatch = "rm -rf doc";
          meta.homepage = "https://github.com/amano-takahisa/case-transform.nvim";
        })
      ] else [ ];

    extraConfigLua =
      if caseTransformExists then ''
        require('case-transform').setup({ default_keymaps = true })
      '' else "";
  };
}
