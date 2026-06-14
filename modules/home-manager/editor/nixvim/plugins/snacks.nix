{ ... }:

{
  programs.nixvim.plugins.snacks = {
    enable = true;
    settings = {
      image = {
        enabled = true;
      };
    };
  };
}

