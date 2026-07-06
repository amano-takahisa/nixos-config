{ pkgs, ... }:

let
  # nixpkgs' mplus-outline-fonts.githubRelease pins coz-m/MPLUS_FONTS at
  # 336fec4e9e7c1e61bd22b82e6364686121cf3932 (2022-05-19), which predates the
  # repo's build-system rewrite (fonts/<Family>/{ttf,otf}/...) and MPLUS U.
  # Track a newer commit until nixpkgs updates its pin.
  mplus-outline-fonts-latest = pkgs.stdenvNoCC.mkDerivation {
    pname = "mplus-outline-fonts-github";
    version = "unstable-2026-07-06";

    src = pkgs.fetchFromGitHub {
      owner = "coz-m";
      repo = "MPLUS_FONTS";
      rev = "2190772c60253615b9acc97281fe8b0eb66c18bf";
      hash = "sha256-k8BVIaAYgU13SWfn/wxLHOQeGHEv462SdUI22dm9bbo=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/fonts/{truetype,opentype}/mplus-outline-fonts
      for family in fonts/*/; do
        cp "$family"/ttf/*.ttf $out/share/fonts/truetype/mplus-outline-fonts/
        cp "$family"/otf/*.otf $out/share/fonts/opentype/mplus-outline-fonts/
      done

      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "M+ Outline Fonts (latest GitHub build, newer than nixpkgs' pin)";
      homepage = "https://mplusfonts.github.io";
      license = licenses.ofl;
      platforms = platforms.all;
    };
  };
in
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
      mplus-outline-fonts-latest
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
