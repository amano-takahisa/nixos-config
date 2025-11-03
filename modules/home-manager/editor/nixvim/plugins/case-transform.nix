{ pkgs, ... }:

let
  caseTransformPath = /home/takahisa/ghq/personal/github.com/amano-takahisa/case-transform.nvim;
  caseTransformExists = builtins.pathExists caseTransformPath;
in
if caseTransformExists then {
  programs.nixvim = {
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
} else {
  warnings = [ "case-transform.nvim not found. Please run: ghq get git@github.com:amano-takahisa/case-transform.nvim.git" ];
}
