{ pkgs, ... }:

{
  home.packages = with pkgs; [
    libreoffice
    thunderbird
    evince # PDF viewer
    # okular        # KDE PDF viewer
    # hunspell      # Spell checker
    # hunspellDicts.en_US
    # hunspellDicts.de_DE
  ];

  xdg.configFile."fontconfig/conf.d/60-japanese.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <!-- Generic family preferences: prefer CJK JP for Japanese text -->
      <alias>
        <family>sans-serif</family>
        <prefer>
          <family>Noto Sans CJK JP</family>
          <family>Noto Sans</family>
        </prefer>
      </alias>
      <alias>
        <family>serif</family>
        <prefer>
          <family>Noto Serif CJK JP</family>
          <family>Noto Serif</family>
        </prefer>
      </alias>
      <alias>
        <family>monospace</family>
        <prefer>
          <family>Noto Sans Mono CJK JP</family>
        </prefer>
      </alias>
      <!-- Fallback from specific Latin Noto font names to CJK variants.
           GTK apps (including LibreOffice) request "Noto Sans" by
           name rather than the generic "sans-serif", so fontconfig would not
           reach the rules above. These append rules ensure Japanese glyphs
           are found even when a specific font name is requested. -->
      <alias>
        <family>Noto Sans</family>
        <accept>
          <family>Noto Sans CJK JP</family>
        </accept>
      </alias>
      <alias>
        <family>Noto Serif</family>
        <accept>
          <family>Noto Serif CJK JP</family>
        </accept>
      </alias>
    </fontconfig>
  '';
}
