{ config, pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ../hardware-configuration.nix
    <nixos-hardware/raspberry-pi/4>
    ../groups/common.nix
  ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  networking.hostName = "ithaca";
  networking.interfaces.wlan0.useDHCP = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Don't change this.
  system.stateVersion = "21.11"; # Did you read the comment?

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;
}
