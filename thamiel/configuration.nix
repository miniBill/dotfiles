{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../groups/common.nix
    ../groups/server.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  networking.hostName = "thamiel";

  system.stateVersion = "23.11";
}
