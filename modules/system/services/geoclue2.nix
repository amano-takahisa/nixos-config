{ config, ... }:

{
  services.geoclue2.enable = true;

  sops.secrets.google_geolocation_api_key = {
    sopsFile = ../../../secrets/msi.yaml;
  };

  sops.templates."geoclue.conf" = {
    path = "/etc/geoclue/geoclue.conf";
    mode = "0644";
    content = ''
      [agent]
      whitelist=geoclue-demo-agent

      [firefox]
      allowed=true
      system=false
      users=

      [wifi]
      url=https://www.googleapis.com/geolocation/v1/geolocate?key=${config.sops.placeholder.google_geolocation_api_key}
    '';
  };
}
