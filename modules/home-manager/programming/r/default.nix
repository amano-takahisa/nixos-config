{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Create an R environment with styler package included
    # This ensures styler is available in R's library path
    (rWrapper.override {
      packages = with rPackages; [
        styler
      ];
    })
  ];
}


