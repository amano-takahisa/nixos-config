{ pkgs, ... }:

{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      nixGrammars = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        diff
        git_rebase
        gitcommit
        go
        gomod
        gosum
        gowork
        html
        javascript
        json
        lua
        markdown
        nix
        python
        query
        regex
        rust
        toml
        tsx
        typescript
        vim
        vimdoc
        yaml
      ];
      settings = {
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = [ "gitcommit" ];
        };
        indent = {
          enable = true;
        };
        incremental_selection = {
          enable = true;
        };
      };
    };
  };
}
