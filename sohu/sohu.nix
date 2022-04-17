{ config, pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ../hardware-configuration.nix
    <nixos-hardware/pine64/pinebook-pro>
    ../groups/common.nix
    ../groups/graphical.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.kernelParams = [ "console=tty0" ];

  boot.initrd.luks.devices = {
    vault = {
      device = "/dev/mmcblk2p2";
      preLVM = true;
      allowDiscards = true;
    };
  };
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  networking.hostName = "sohu"; # Define your hostname.
  networking.interfaces.wlan0.useDHCP = false;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "pinebookpro-ap6256-firmware" ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Don't change this.
  system.stateVersion = "21.11"; # Did you read the comment?
}
