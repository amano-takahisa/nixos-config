{ pkgs, llm-agents, ... }:

{
  programs.opencode = {
    enable = true;
    package = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
  };
}
