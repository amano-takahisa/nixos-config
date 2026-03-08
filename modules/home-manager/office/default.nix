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
}
