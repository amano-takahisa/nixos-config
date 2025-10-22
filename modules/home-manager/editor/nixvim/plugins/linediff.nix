{ ... }:

{
  programs.nixvim = {
    plugins.linediff = {
      enable = true;
    };
  };
}
