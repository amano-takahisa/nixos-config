{ pkgs, ... }:

{
  # Enable Podman
  virtualisation.podman = {
    enable = true;
    # Create a `docker` alias for podman, to use it as a drop-in replacement
    dockerCompat = false; # Set to false since Docker is also installed
    # Required for containers under podman-compose to be able to talk to each other
    defaultNetwork.settings.dns_enabled = true;
  };

  # Install podman-compose
  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
