{ pkgs, ... }:

{
  home.packages = with pkgs; [
    thunderbird
    evince # PDF viewer
    # okular        # KDE PDF viewer
    # hunspell      # Spell checker
    # hunspellDicts.en_US
    # hunspellDicts.de_DE
  ];

  # User-level fontconfig to prefer CJK fonts for Japanese text.
  # This is placed in ~/.config/fontconfig/conf.d/ which is read by both
  # the system and Flatpak sandboxes (via 50-user.conf inside Flatpak).
  # Make CJK fonts accessible to Flatpak sandboxes.
  # Flatpak has default read access to ~/.local/share/fonts
  # (mounted at /run/host/user-fonts inside the sandbox).
  xdg.dataFile."fonts/noto-cjk-sans".source =
    "${pkgs.noto-fonts-cjk-sans}/share/fonts/opentype";
  xdg.dataFile."fonts/noto-cjk-serif".source =
    "${pkgs.noto-fonts-cjk-serif}/share/fonts/opentype";

  # User-level fontconfig to prefer CJK fonts for Japanese text.
  # This is placed in ~/.config/fontconfig/conf.d/ which is read by both
  # the system and Flatpak sandboxes (via 50-user.conf inside Flatpak).
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
           GTK apps (including LibreOffice Flatpak) request "Noto Sans" by
           name rather than the generic "sans-serif", so fontconfig would not
           reach the rules above. These append rules ensure Japanese glyphs
           are found even when a specific font name is requested. -->
      <alias>
        <family>Noto Sans</family>
        <append>
          <family>Noto Sans CJK JP</family>
        </append>
      </alias>
      <alias>
        <family>Noto Serif</family>
        <append>
          <family>Noto Serif CJK JP</family>
        </append>
      </alias>
    </fontconfig>
  '';
}
