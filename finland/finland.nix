# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      <nixos-hardware/dell/xps/15-7590>
      # Include the results of the hardware scan.
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

  networking.hostName = "finland"; # Define your hostname.
  networking.interfaces.wlp59s0.useDHCP = false;
  services.tailscale.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpitool
    cpufrequtils
    dmidecode
    lm_sensors
    openconnect
    pavucontrol
    powertop
    tailscale
    yakuake
  ];

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  # List services that you want to enable:

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 1234 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;
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

  system.autoUpgrade.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
