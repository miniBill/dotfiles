# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  ip = "185.216.25.227";
in
{
  imports = [
    ./hardware-configuration.nix

    ../groups/common.nix
    ../groups/server.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking.hostName = "milky";

  # services.sslh = {
  #   enable = true;
  #   settings.transparent = true;
  #   listenAddresses = [ ip ];
  # };

  # services.mysql = {
  #   enable = true;
  #   package = pkgs.mariadb;
  #   bind = "127.0.0.1";
  #   # ensureDatabases = ["latisanalingue"];
  #   # ensureUsers = [
  #   #   {
  #   #     name = "latisanalingue";
  #   #     ensurePermissions = {
  #   #       "latisanalingue.*" = "ALL PRIVILEGES";
  #   #     };
  #   #   }
  #   # ];
  # };

  virtualisation.libvirtd.enable = true;

  # Open ports in the firewall.
  networking = {
    usePredictableInterfaceNames = false;
    interfaces.eth0.ipv4.addresses = [{
      address = ip;
      prefixLength = 24;
    }];
    # interfaces.eth0.ipv6.addresses = [{
    #   address = "2a07:abc4::1:b0e";
    #   prefixLength = 48;
    # }];
    defaultGateway = "185.216.25.1";
    # defaultGateway6 = {
    #   address = "2a07:abc4::1";
    # };
    nameservers = [
      # "2a07:abc4:2::19:1"
      # "2a07:abc4:2::19:2"
      "1.1.1.1"
    ];
    firewall.allowedTCPPorts = [ 2222 ];
  };

  users.users = {
    minibill = {
      isNormalUser = true;
      extraGroups = [ "wheel" "libvirtd" ];
    };
    silvia = {
      isNormalUser = true;
      initialHashedPassword = "$6$JTmVAGMfLoNS0hhL$9Z9/bQidoTy.OMiX4e0/tjveK1XwyZSwJXd6VZfJu007vGXxyza5mhxceKz9iHbQzpZL/BA6TmCOQQ0vJE4Pg1";
    };
    root.initialHashedPassword = "$6$n93YmDo6eAAe8XdK$yYrlybyx6Tmh6HdrqOJPNV1h7KS/9/ybH.Es71UteKlnZErE5Sgg75XnwJtSa/nhBAdnYx.NSWfogx/wBhI6//";
  };

  system.stateVersion = "19.03";
}
