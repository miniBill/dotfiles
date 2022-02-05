{ config, lib, pkgs, ... }:

{
  boot.kernelParams = [ "mem_sleep_default=deep" ];
  services.thermald.enable = true;
  services.fwupd.enable = true;
}
