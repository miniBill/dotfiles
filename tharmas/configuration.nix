{ pkgs, ... }:
let
  ip = "149.91.81.222";
in
{
  imports = [
    ./hardware-configuration.nix
    pkgs.nixosModules.profiles.qemu-guest

    ./cjdns.nix
    ./www.nix
    ../groups/common.nix
    ../groups/server.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    mirroredBoots = [{
      devices = [ "nodev" ];
      path = "/boot-fallback";
    }];
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "tharmas";

  virtualisation.lxd.enable = true;
  services.sslh = {
    enable = true;
    transparent = true;
    listenAddress = ip;
  };
  services.openssh = {
    permitRootLogin = "yes";
    ports = [ 22 2222 ];
  };
  networking = {
    usePredictableInterfaceNames = false;
    interfaces.eth0.ipv4.addresses = [{
      address = ip;
      prefixLength = 24;
    }];
    interfaces.eth0.ipv6.addresses = [{
      address = "2a07:abc4::1:b0e";
      prefixLength = 64;
    }];
    defaultGateway = "149.91.81.1";
    defaultGateway6 = {
      address = "2a07:abc4::1";
      interface = "eth0";
    };
    nameservers = [
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
      "1.1.1.1"
    ];
    firewall.allowedTCPPorts = [
      80 # Http - nginx
      443 # Https - nginx
      2222 # Ssh alternate port
      30033 # ?
      10011 # ?
      4144 # ?
      25565 # ?
    ];
    firewall.allowedUDPPorts = [
      54345 # ?
      9987 # ?
      25565 # ?
    ];
  };
  users.mutableUsers = false;
  users.users = {
    minibill = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPassword = "$6$dPi0t.m3Rat601ku$zULH0TmfZQPZzxnQEchMGKLEUxnEFYkT47zWnNTfm3yopOEo5CdD6Ymhr1yIakq5zwtIaXDCAoaJWNYm5My0W0";
    };
    silvia = {
      isNormalUser = true;
      hashedPassword = "$6$JTmVAGMfLoNS0hhL$9Z9/bQidoTy.OMiX4e0/tjveK1XwyZSwJXd6VZfJu007vGXxyza5mhxceKz9iHbQzpZL/BA6TmCOQQ0vJE4Pg1";
    };
    holydarkness = {
      isNormalUser = true;
      hashedPassword = "$6$H1taZPIYM3/Yfbo8$dgRRy9dpHtIue9ygwFdz3egnmhhOZDWnnPhmWQgUGpp7oPo52973j.q62sMjjIOrf/sSUXGVa2MWWrmKpZ39X1";
    };
    latisanalingue = {
      group = "latisanalingue";
    };
    root = {
      hashedPassword = "$6$fWJ47Jp5U7LytfoV$Z1XqNGZIA0m9MUtNgmmjIGqsKkyoqT0PhQ0F7OyMrElwtjHeRrDUu5PzISxuUXgcxIauyA/8R/IH7r7cWq4Fu/";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFQ9ViwGQWWPXKIWPLDH3HcDM0oUBdvCFmMleuSQSiH ohana@tyrant"
      ];
    };
    timerune = {
      isNormalUser = true;
    };
  };
  users.groups.latisanalingue = { };
  system.stateVersion = "22.11";
}
