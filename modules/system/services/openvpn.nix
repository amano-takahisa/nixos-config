# OpenVPN client configuration
# Usage:
#   1. Place your .ovpn file at /etc/openvpn/client.ovpn
#   2. Start the VPN: sudo systemctl start openvpn-client
#   3. Stop the VPN:  sudo systemctl stop openvpn-client
{ ... }:
{
  services.openvpn.servers = {
    client = {
      config = ''
        config /etc/openvpn/client.ovpn
        data-ciphers AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305:AES-128-CBC
      '';
      autoStart = false;
      updateResolvConf = true;
    };
  };
}
