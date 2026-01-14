{ pkgs, ... }:

let
  gwq = pkgs.buildGoModule rec {
    pname = "gwq";
    version = "0.0.7";

    src = pkgs.fetchFromGitHub {
      owner = "d-kuro";
      repo = "gwq";
      rev = "v${version}";
      hash = "sha256-CvfAxTd7/AK98TSJDM+iNJTUALMKMk8esXEn7Fuumik=";
    };

    vendorHash = "sha256-c1vq9yETUYfY2BoXSEmRZj/Ceetu0NkIoVCM3wYy5iY=";

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
