{ pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "case-transform.nvim";
        version = "dev";
        src = /home/takahisa/ghq/personal/github.com/amano-takahisa/case-transform.nvim;
        postPatch = "rm -rf doc";
        meta.homepage = "https://github.com/amano-takahisa/case-transform.nvim";
      })
    ];

    extraConfigLua = ''
      require('case-transform').setup({ default_keymaps = true })
    '';
  };
}
