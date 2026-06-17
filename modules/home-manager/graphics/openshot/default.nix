{ pkgs, lib, ... }:

let
  profilesDir = ./profiles;
in
{
  home.packages = with pkgs; [
    openshot-qt
  ];

  home.file = lib.mapAttrs'
    (name: _: {
      name = ".openshot_qt/profiles/${name}";
      value = { source = profilesDir + "/${name}"; };
    })
    (builtins.readDir profilesDir);
}

