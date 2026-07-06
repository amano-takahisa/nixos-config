{ pkgs, ... }:

let
  gwq = pkgs.buildGoModule rec {
    pname = "gwq";
    version = "0.1.1"; # released on May 2, 2026

    src = pkgs.fetchFromGitHub {
      owner = "d-kuro";
      repo = "gwq";
      rev = "v${version}";
      hash = "sha256-MfCYFbODWnfPxx+6sLlcMT6tqghgILHB13+ccYqVjBA=";
    };

    vendorHash = "sha256-4K01Xf1EXl/NVX1loQ76l1bW8QglBAQdvlZSo7J4NPI=";

    # Tests require git in PATH and a functional git environment
    doCheck = false;

    meta = with pkgs.lib; {
      description = "Git worktree manager with fuzzy finder";
      homepage = "https://github.com/d-kuro/gwq";
      license = licenses.mit;
    };
  };
in
{
  home.packages = [ gwq ];
}
