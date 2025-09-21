{ pkgs, ... }:

{
  imports = [
    ./claude-code
    ./gh-cli
    ./git
    ./lazygit
    ./ripgrep
  ];
}
