{ pkgs, ... }:

{
  home.packages = with pkgs; [
    apptainer
  ];
}


