{ config, pkgs, lib, ... }:

let
  blockyUDPPort = 53;
in
{
  networking.firewall.allowedUDPPorts = [
    blockyUDPPort
  ];

  services.blocky = {
    enable = true;
    settings = {
      upstream = {
        default = [
          "46.182.19.48"
          "80.241.218.68"
          "tcp-tls:fdns1.dismail.de:853"
          "https://dns.digitale-gesellschaft.ch/dns-query"
        ];
      };
      blocking = {
        blackLists = {
          ads = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
          ];
        };
        clientGroupsBlock = {
          default = [
            "ads"
          ];
        };
      };
      port = blockyUDPPort;
      httpPort = 4000;
    };
  };
}
