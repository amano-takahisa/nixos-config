{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-desktop
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/bitwarden" = [ "bitwarden.desktop" "Bitwarden.desktop" ];
    };
  };
}

