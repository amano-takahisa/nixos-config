{ pkgs, lib, ... }:

let
  profilesDir = ./profiles;
  # Match the C++20 types exposed by the current protobuf/Abseil headers.
  libopenshot = pkgs.libopenshot.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'set(CMAKE_CXX_STANDARD 17)' 'set(CMAKE_CXX_STANDARD 20)'
    '';
  });
in
{
  home.packages = [
    (pkgs.openshot-qt.override { inherit libopenshot; })
  ];

  home.file = lib.mapAttrs'
    (name: _: {
      name = ".openshot_qt/profiles/${name}";
      value = { source = profilesDir + "/${name}"; };
    })
    (builtins.readDir profilesDir);
}

