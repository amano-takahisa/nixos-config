{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "plasma-notify";
      runtimeInputs = [ pkgs.libnotify ];
      text = builtins.readFile ./plasma-notify.sh;
    })
  ];
}
