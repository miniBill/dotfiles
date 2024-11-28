{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../groups/machines/common.nix
    ../../groups/machines/server.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = false;

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  networking.hostName = "thamiel";

  system.stateVersion = "23.11";
}
