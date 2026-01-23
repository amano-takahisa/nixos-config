{ pkgs, llm-agents, ... }:

{
  programs.opencode = {
    enable = true;
    package = llm-agents.packages.${pkgs.system}.opencode;
  };
}
