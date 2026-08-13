{ lib, appimageTools, fetchurl }:

let
  pname = "amethyst";
  version = "1.13.1";

  src = fetchurl {
    url = "https://github.com/vitorpamplona/amethyst/releases/download/v${version}/amethyst-desktop-${version}-linux-x64.AppImage";
    hash = "sha256-PNfg+KLhRVUWVNpEoaMz2qZXDtuMEvjb6wHsjAJVQWo=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [
    stdenv.cc.cc.lib
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
  ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/amethyst.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/amethyst.png $out/share/icons/hicolor/512x512/apps/amethyst.png
    substituteInPlace $out/share/applications/amethyst.desktop \
      --replace-fail 'Exec=Amethyst %u' 'Exec=${pname} %u'
  '';

  meta = {
    description = "Nostr client for desktop (Amethyst)";
    homepage = "https://github.com/vitorpamplona/amethyst";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
