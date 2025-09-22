{ config, pkgs, ... }:

{
  # Enable rootless Docker service
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}