{ ... }:

{
  services.syncthing = {
    enable = true;

    settings = {
      devices = {
        nas-fs6706t = {
          id = "TZG4OUM-4ZVFHK6-KTQEQDJ-GSACV3S-LAOFG5S-GJMB7OP-TXRZI2K-IGVEFAE";
        };
      };

      folders = {
        documents = {
          path = "~/Documents/syncthing";
          devices = [ "nas-fs6706t" ];
          type = "sendreceive";
        };
      };
    };
  };
}
