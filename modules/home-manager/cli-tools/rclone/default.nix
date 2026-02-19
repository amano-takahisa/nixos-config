{ config, ... }:

{
  programs.rclone = {
    enable = true;
  };

  sops.secrets = {
    rclone_r2_access_key_id = { };
    rclone_r2_secret_access_key = { };
    rclone_r2_endpoint = { };
  };

  sops.templates."rclone.conf" = {
    content = ''
      [r2]
      type = s3
      provider = Cloudflare
      access_key_id = ${config.sops.placeholder.rclone_r2_access_key_id}
      secret_access_key = ${config.sops.placeholder.rclone_r2_secret_access_key}
      endpoint = ${config.sops.placeholder.rclone_r2_endpoint}
    '';
    path = "${config.home.homeDirectory}/.config/rclone/rclone.conf";
  };
}
