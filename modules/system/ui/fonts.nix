# Japanese fonts configuration for programming
{ config, pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Japanese fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      ipafont
      source-han-sans
      source-han-serif

      # Programming fonts with Japanese support
      plemoljp # PlemolJP - 日本語プログラミング用フォント
      hackgen-nf-font # HackGen Nerd Font - 白源
      udev-gothic-nf # UDEV Gothic Nerd Font

      # Popular programming fonts
      jetbrains-mono
      fira-code
      source-code-pro

      # Nerd Fonts collection
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.sauce-code-pro
      nerd-fonts.ubuntu-mono
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.inconsolata

      # Additional useful fonts
      noto-fonts
      noto-fonts-emoji
      liberation_ttf
      dejavu_fonts
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif CJK JP" "Noto Serif" ];
        sansSerif = [ "Noto Sans CJK JP" "Noto Sans" ];
        monospace = [ "PlemolJP" "JetBrains Mono" "Fira Code" ];
        emoji = [ "Noto Color Emoji" ];
      };
      localConf = ''
        <fontconfig>
          <alias>
            <family>sans-serif</family>
            <prefer>
              <family>Noto Sans JP</family>
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
              <family>PlemolJP</family>
              <family>JetBrains Mono</family>
            </prefer>
          </alias>
        </fontconfig>
      '';
    };
  };
}
