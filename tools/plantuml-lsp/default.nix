{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "plantuml-lsp";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "ptdewey";
    repo = "plantuml-lsp";
    rev = "v${version}";
    sha256 = "sha256-kI7FpCM0sGO/cjEaYPsKRc4+6d1s1SxDIGKs33ddxts=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Language Server Protocol implementation for PlantUML";
    homepage = "https://github.com/ptdewey/plantuml-lsp";
    license = licenses.mit;
    maintainers = [ ];
  };
}
