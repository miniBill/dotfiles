{ config, pkgs, lib, ... }:

let
  blockyUDPPort = 53;
in
{
  networking.firewall.allowedTCPPorts = [
    blockyUDPPort
  ];
  networking.firewall.allowedUDPPorts = [
    blockyUDPPort
  ];

  services.blocky = {
    enable = true;
    settings = {
      upstream = {
        default = [
          "9.9.9.9"
          "8.8.8.8"
          "8.8.4.4"
          "85.38.28.2"
          "85.38.28.3"
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
