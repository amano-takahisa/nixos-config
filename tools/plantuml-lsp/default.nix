{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "plantuml-lsp";
  version = "unstable-2025-06-17";

  src = fetchFromGitHub {
    owner = "ptdewey";
    repo = "plantuml-lsp";
    rev = "5000950f53d5c84da6d1b0805d2cfb39d3cd83d1";
    sha256 = "0shrxqlinlgzh7lgsjvfpy0n248javh51v8zmmglb0pc489m640n";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Language Server Protocol implementation for PlantUML";
    homepage = "https://github.com/ptdewey/plantuml-lsp";
    license = licenses.mit;
    maintainers = [ ];
  };
}
