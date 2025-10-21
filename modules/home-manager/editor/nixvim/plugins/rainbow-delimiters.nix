{ ... }:

{
  programs.nixvim.plugins.rainbow-delimiters = {
    enable = true;
    settings.query = {
      "" = "rainbow-delimiters";
      lua = "rainbow-blocks";
    };
  };
}
