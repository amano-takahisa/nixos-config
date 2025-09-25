{ ... }:

{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight = {
          enable = true;
        };
        indent = {
          enable = true;
        };
        ensure_installed = [
          "bash"
          "c"
          "html"
          "javascript"
          "json"
          "lua"
          "markdown"
          "nix"
          "python"
          "query"
          "regex"
          "rust"
          "tsx"
          "typescript"
          "vim"
          "vimdoc"
          "yaml"
        ];
        auto_install = true;
      };
    };
  };
}
