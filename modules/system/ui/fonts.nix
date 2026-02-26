{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      dejavu_fonts
      fira-code
      font-awesome
      font-awesome_5
      hackgen-nf-font
      ipafont
      liberation_ttf
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.inconsolata
      nerd-fonts.jetbrains-mono
      nerd-fonts.sauce-code-pro
      nerd-fonts.ubuntu-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji
      source-code-pro
      source-han-sans
      source-han-serif
      udev-gothic-nf
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif CJK JP" "Noto Serif" ];
        sansSerif = [ "Noto Sans CJK JP" "Noto Sans" ];
        monospace = [ "HackGen Console NF" "Hack Nerd Font Mono" "Noto Sans Mono CJK JP" ];
        emoji = [ "Noto Color Emoji" ];
      };
      # localConf = ''
      #   <fontconfig>
      #     <alias>
      #       <family>sans-serif</family>
      #       <prefer>
      #         <family>Noto Sans JP</family>
      #         <family>Noto Sans CJK JP</family>
      #         <family>Noto Sans</family>
      #       </prefer>
      #     </alias>
      #     <alias>
      #       <family>serif</family>
      #       <prefer>
      #         <family>Noto Serif CJK JP</family>
      #         <family>Noto Serif</family>
      #       </prefer>
      #     </alias>
      #     <alias>
      #       <family>monospace</family>
      #       <prefer>
      #         <family>HackGen Console NF</family>
      #         <family>Hack Nerd Font Mono</family>
      #       </prefer>
      #     </alias>
      #   </fontconfig>
      # '';
    };
  };
}
