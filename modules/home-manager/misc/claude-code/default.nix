{ pkgs, nodePkgs ? null, ... }:

{
  home.packages =
    if nodePkgs != null then [
      nodePkgs."@anthropic-ai/claude-code"
    ] else with pkgs; [
      claude-code
    ];
}
