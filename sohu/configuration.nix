{ lib, nixos-hardware, ... }:

{
  imports = [
    nixos-hardware.nixosModules.pine64-pinebook-pro
    ./hardware-configuration.nix
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

  networking.hostName = "sohu";
  networking.interfaces.wlan0.useDHCP = false;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "pinebookpro-ap6256-firmware-xz" ];

  # Don't change this.
  system.stateVersion = "21.11"; # Did you read the comment?
}
