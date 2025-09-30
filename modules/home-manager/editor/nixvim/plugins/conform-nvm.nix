{ pkgs, ... }:

{
  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    # autoInstall.enable = true;

    settings = {
      formatters_by_ft = {
        # List of available formatters can be found here:
        # https://github.com/stevearc/conform.nvim/#formatters
        bash = [ "shellcheck" "shfmt" ];
        javascript = [ "prettierd" ];
        nix = [ "nixpkgs_fmt" ];
        python = [ "isort" "ruff_fix" "ruff_format" ];
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

  # # Install formatters
  # home.packages = with pkgs; [
  #   ruff # Python formatter/linter
  #   nixpkgs-fmt # Nix formatter
  # ];
}
