{ pkgs, ... }:

{
  programs.nixvim.plugins.conform-nvim = {
    enable = true;

    settings = {
      formatters_by_ft = {
        python = [ "ruff_format" ];
        nix = [ "nixpkgs_fmt" ];
      };

    };
  };

  # Add keymap for conform formatting
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>lf";
      action.__raw = ''
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end
      '';
      options = {
        desc = "Format with conform.nvim";
      };
    }
  ];

  # Install formatters
  home.packages = with pkgs; [
    ruff         # Python formatter/linter
    nixpkgs-fmt  # Nix formatter
  ];
}