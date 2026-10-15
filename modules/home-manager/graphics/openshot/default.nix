{ lib, ... }:

let
  profilesDir = ./profiles;
in
{
  # OpenShot is temporarily excluded: libopenshot fails to build with the
  # current toolchain (C++20 lerp ambiguity). Re-enable after verifying a fix.

  home.file = lib.mapAttrs'
    (name: _: {
      name = ".openshot_qt/profiles/${name}";
      value = { source = profilesDir + "/${name}"; };
    })
    (builtins.readDir profilesDir);
}
