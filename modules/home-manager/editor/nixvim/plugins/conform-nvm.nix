{ ... }:

{
  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    autoInstall.enable = true;

    settings = {
      formatters_by_ft = {
        # Use individual formatters for editor formatting
        # This works across all projects without requiring treefmt.toml
        # For nixos-config project, use `nix fmt` or pre-commit for treefmt integration
        bash = [ "shfmt" ];
        go = [ "goimports" "gofmt" ];
        javascript = [ "prettier" ];
        javascriptreact = [ "prettier" ];
        typescript = [ "prettier" ];
        typescriptreact = [ "prettier" ];
        json = [ "prettier" ];
        yaml = [ "prettier" ];
        markdown = [ "prettier" ];
        nix = [ "nixpkgs_fmt" ];
        python = [ "isort" "ruff_fix" "ruff_format" ];
        rust = [ "rustfmt" ];
        toml = [ "taplo" ];
        fish = [ "fish_indent" ];
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
