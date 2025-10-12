{ pkgs, lib, ... }:

let
  pluginPath = /home/takahisa/ghq/personal/github.com/amano-takahisa/case-transform.nvim;
  pluginExists = builtins.pathExists pluginPath;
in
{
  programs.nixvim = {
    # Load the local plugin for development if it exists
    extraPlugins = lib.optionals pluginExists [
      (pkgs.vimUtils.buildVimPlugin rec {
        pname = "case-transform.nvim";
        version = "dev";
        src = pluginPath;
        # Remove empty doc directory to avoid helptags generation error
        postPatch = ''
          rm -rf doc
        '';
        meta.homepage = "https://github.com/amano-takahisa/case-transform.nvim";
      })
    ];

    extraConfigLua = lib.optionalString pluginExists ''
      require('case-transform').setup({
        default_keymaps = true,
      })
    '';
  };
}
