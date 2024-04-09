{ ... }:

{
  imports = [
    nixos-hardware.nixosModules.raspberry-pi-4
    ./hardware-configuration.nix
    ./pi-myhole.nix
    ../groups/common.nix
  ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  networking.hostName = "ithaca";
  networking.interfaces.wlan0.useDHCP = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [ ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "21.11";

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;
}
