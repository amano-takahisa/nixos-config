{ pkgs, ... }:

{
  imports = [
    ./git
    ./ripgrep
    ./claude-code
  ];
}