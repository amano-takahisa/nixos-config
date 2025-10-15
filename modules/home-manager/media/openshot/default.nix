{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # openshot-qt
    # #################
    # Since openshot-qt depends on qt5 which has security vulnerabilities,
    # instead of installing it directly, use it in a nix-shell by running:
    #
    # ```
    # NIXPKGS_ALLOW_INSECURE=1 nix-shell -p openshot-qt --run openshot-qt
    # ```
    # #################
  ];
}

