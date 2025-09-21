{ pkgs, ... }:

{
  imports = [
    ./git
    ./gh-cli
    ./ripgrep
    ./claude-code
  ];
}
