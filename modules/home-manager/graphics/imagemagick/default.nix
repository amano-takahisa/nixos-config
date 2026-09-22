{ pkgs, lib, ... }:

let
  # ImageMagick の SVG デコーダは stealth delegate `svg:decode` を最優先で使い、
  # これは PATH 上の `inkscape` を実行する (coders/svg.c: RenderInkscapeImage)。
  # inkscape 1.4 は起動時に D-Bus へアプリ登録を行うため、複数プロセスが
  # 同時に起動すると uncaught な Gio::DBus::Error で abort する
  # (inkscape#4716, NixOS/nixpkgs#308577)。
  # image.nvim などのプレビューは SVG を並列で変換するため、この abort が
  # magick の失敗として表面化する。delegate を同梱の librsvg に差し替えて
  # inkscape を呼ばせない。
  # %s は ImageMagick 側で (入力, 出力, dpi, 背景色, 不透明度) の順に展開される。
  inkscapeDelegate = "command=\"&apos;inkscape&apos; &apos;%s&apos; &apos;--export-filename=%s&apos; &apos;--export-dpi=%s&apos; &apos;--export-background=%s&apos; &apos;--export-background-opacity=%s&apos;\"";
  rsvgDelegate = "command=\"&apos;${pkgs.librsvg}/bin/rsvg-convert&apos; &apos;%s&apos; --output &apos;%s&apos;\"";

  originalDelegates = builtins.readFile "${pkgs.imagemagick}/etc/ImageMagick-7/delegates.xml";
  patchedDelegates = lib.replaceStrings [ inkscapeDelegate ] [ rsvgDelegate ] originalDelegates;

  # MAGICK_CONFIGURE_PATH は探索順が先頭で、同名 delegate は先勝ち。
  # (~/.config/ImageMagick は探索順が後ろのため上書きできない)
  magickConfig = pkgs.writeTextDir "delegates.xml" (
    if patchedDelegates == originalDelegates then
      throw "imagemagick: delegates.xml の svg:decode 定義が変わった。inkscape#4716 回避の書き換えを更新すること"
    else
      patchedDelegates
  );

  # セッション環境変数に依存させないため、バイナリ側で MAGICK_CONFIGURE_PATH を設定する。
  imagemagick = pkgs.symlinkJoin {
    name = "imagemagick-rsvg-svg-delegate";
    paths = [ pkgs.imagemagick ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for bin in ${pkgs.imagemagick}/bin/*; do
        name=$(basename "$bin")
        rm -f $out/bin/$name
        makeWrapper "$bin" "$out/bin/$name" \
          --set MAGICK_CONFIGURE_PATH ${magickConfig}
      done
    '';
  };
in
{
  home.packages = [
    imagemagick
  ];
}
