{ pkgs, ... }:

{
  home.packages = [
    (pkgs.buildFHSEnv {
      name = "uv";
      runScript = "uv";
      targetPkgs = pkgs: with pkgs; [ uv ];
    })
  ];
}
