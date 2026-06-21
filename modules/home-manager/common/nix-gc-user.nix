# User-level Nix garbage collection.
#
# The system-wide `nix.gc` service (see modules/system/nix-gc.nix) runs as root
# and only prunes profiles under /nix/var/nix/profiles (the system profile and
# the legacy per-user profiles). It does NOT reach user-owned profiles in
# ~/.local/state/nix/profiles, where standalone `home-manager switch` and
# `nix profile` generations accumulate indefinitely and keep their closures
# alive as GC roots. This timer collects those as the user, weekly.
{ pkgs, ... }:

{
  systemd.user.services.nix-user-gc = {
    Unit.Description =
      "Garbage collect user Nix profiles (home-manager, nix profile)";
    Service = {
      Type = "oneshot";
      # Deletes generations older than 14 days across all user profiles, then
      # collects any store paths that are no longer referenced.
      ExecStart =
        "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 14d";
    };
  };

  systemd.user.timers.nix-user-gc = {
    Unit.Description = "Weekly user Nix garbage collection";
    Timer = {
      OnCalendar = "weekly";
      Persistent = true; # run on next boot if the machine was off at the time
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
