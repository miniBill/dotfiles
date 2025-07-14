{ pkgs, ... }:
let
  ip = "144.76.3.185";
in
{
  imports = [
    ./hardware-configuration.nix

    # ./cjdns.nix
    ./www.nix
    ../../groups/machines/common.nix
    ../../groups/machines/server.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    mirroredBoots = [
      {
        devices = [ "nodev" ];
        path = "/boot-fallback";
      }
    ];
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = false;

  networking.hostName = "tharmas";

  # virtualisation.lxd.enable = true;
  services.sslh = {
    enable = true;
    settings.transparent = true;
    listenAddresses = [ ip ];
  };
  networking = {
    usePredictableInterfaceNames = false;
    interfaces.eth0.ipv4.addresses = [
      {
        address = ip;
        prefixLength = 27;
      }
    ];
    interfaces.eth0.ipv6.addresses = [
      {
        address = "2a01:4f8:190:738b::";
        prefixLength = 64;
      }
    ];
    defaultGateway = "144.76.3.161";
    defaultGateway6 = {
      address = "fe80::1";
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
      14300 # Minecraft
    ];
    firewall.allowedUDPPorts = [
      54345 # ?
      9987 # ?
    ];
  };
  users.mutableUsers = false;
  users.users = {
    minibill = {
      isNormalUser = true;
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
    emilywelbers = {
      isNormalUser = true;
      group = "emilywelbers";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGAVCUqG9wVONKAUB449Zn+B/6nbKPFOlCcyCC55u3K minibill@uriel"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC47L5U+uP74A6ZPr05Emp7eNx1Qge9WkyBe7Er7NPb1LhVYCH7nJJtR4AFCvXRI9ekll8Bz7IZUs1OOqCBffXVpHcxM686OMMttCW10OMwOnNE6s85nQUtAMSLSPq/KBh4hlov0BcX5FDvJ5n7QvmmjWOQIfsfc/Ipgx1QFDHoqwQKgIZSKDJH9rPKD2mpXm/L+4f7pDlD0ULLqa/I/p5eroE0tHo5fGtkK1vJSdONACGEDW+aeafGi1bXWnU5XM2qMQ7AW6KzpdBtXleeSS4NCcrJ2lgJXGYWDHDkc2wNVCEngbC4uOED6Gj6a65HXE6UyyZFRQk1a7vY2tMO+aip wouter"
      ];
    };
    root = {
      hashedPassword = "$6$fWJ47Jp5U7LytfoV$Z1XqNGZIA0m9MUtNgmmjIGqsKkyoqT0PhQ0F7OyMrElwtjHeRrDUu5PzISxuUXgcxIauyA/8R/IH7r7cWq4Fu/";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFQ9ViwGQWWPXKIWPLDH3HcDM0oUBdvCFmMleuSQSiH ohana@tyrant"
      ];
    };
    timerune = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKH24XAIEHU0qkEd4Mj0wQVqLR9Zu5hxGHtyWVaQ2b0t root@HalStrider"
      ];
    };
    martin = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ7MIVmOTCjW8CUjx1me8pCaholxqKZlnmSTXXbXAd5v martinsstewart@gmail.com"
      ];
    };
  };
  users.groups = {
    emilywelbers = { };
  };
  system.stateVersion = "22.11";
}
