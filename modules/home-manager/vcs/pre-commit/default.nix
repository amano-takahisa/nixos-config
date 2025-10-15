{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (buildFHSEnv {
      name = "pre-commit";
      runScript = "pre-commit";
      targetPkgs = pkgs: with pkgs; [ pre-commit ];
    })

    treefmt

    # Formatters used by treefmt
    nixpkgs-fmt # Nix formatter
    nodePackages.prettier # JavaScript/TypeScript/JSON/YAML/Markdown formatter
    shfmt # Shell script formatter
    ruff # Python formatter
  ];
}
