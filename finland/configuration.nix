{ config, pkgs, ... }:

{
  imports = [
    <nixos-hardware/dell/xps/15-7590>
    ../hardware-configuration.nix
    ./toPR.nix
    ../groups/common.nix
    ../groups/graphical.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    vault = {
      device = "/dev/disk/by-uuid/c12d264a-cd34-447b-9fab-ba5c0570c153";
      preLVM = true;
      allowDiscards = true;
    };
  };
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  networking.hostName = "finland";
  networking.interfaces.wlp59s0.useDHCP = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cpufrequtils
    dmidecode
    lm_sensors
    openconnect
    powertop
  ];

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  # List services that you want to enable:

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 1234 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  services.udev.extraRules = ''
    # Rule for Logitech headset
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0a87", GROUP="plugdev"
  '';

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };
  programs.adb.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.llibinim = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "plugdev" ];
  };
  users.groups.plugdev = { };

  system.stateVersion = "20.03";
}
