{ pkgs, ... }:

{
  home.packages = with pkgs; [
    slack
  ];

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/slack" = "slack.desktop";
  };
}
