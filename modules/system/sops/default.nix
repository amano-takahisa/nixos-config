{
  # sops-nix configuration
  # See: https://github.com/Mic92/sops-nix

  # Use a dedicated age key file
  # Copy ~/.config/sops/age/keys.txt to /var/lib/sops-nix/key.txt on each host
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  # Alternatively, use SSH host keys as age keys (if available)
  # sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # Default sops file for secrets
  sops.defaultSopsFile = ../../../secrets/example.yaml;

  # Example secret configuration
  # Secrets are available at /run/secrets/<name> after nixos-rebuild
  sops.secrets.example_secret = { };

  # Example with permissions:
  # sops.secrets."myservice/password" = {
  #   owner = "myuser";
  #   mode = "0400";
  # };
}
