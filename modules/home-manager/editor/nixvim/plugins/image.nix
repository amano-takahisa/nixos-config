{ ... }:

{
  programs.nixvim.plugins.image = {
    enable = true;
    settings = {
      backend = "kitty";
      processor = "magick_cli";
    };
  };
}
