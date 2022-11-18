# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  # pinned-unstable = import ./pinned-unstable.nix;
  # openrgb-rules = builtins.fetchurl {
  #   url =
  #     "https://gitlab.com/CalcProgrammer1/OpenRGB/-/raw/master/60-openrgb.rules";
  # };

in
{
  imports = [
    # Include the results of the hardware scan.
    ../hardware-configuration.nix
    <musnix>
    ../groups/common.nix
    ../groups/graphical.nix
    ../groups/steam.nix
    # ./web.nix
    ../cachix.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    mirroredBoots = [{
      devices = [ "nodev" ];
      path = "/boot-fallback";
    }];
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = false;

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.blacklistedKernelModules = [ "snd_hda_codec_hdmi" ];

  networking.hostName = "uriel"; # Define your hostname.
  networking.interfaces.wlo1.useDHCP = false;

  boot.kernelModules = [
    #  RGB
    "i3c-dev"
    "i2c-i801"
    "i2c-nct6775"
    # IOMMU
    # "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd"
  ];
  # boot.kernelPatches = [
  #  {
  #    name = "OpenRGB patch";
  #    patch = builtins.fetchurl "https://gitlab.com/CalcProgrammer1/OpenRGB/-/raw/0c45e26c98d5501ea7e575172e302b3109b3c7f5/OpenRGB.patch";
  #  }
  # ];

  boot.kernelParams = [
    "intel_iommu=on"
    "pci=assign-busses,hpbussize=0x33,realloc,hpmemsize=128M,hpmemprefsize=1G"
    # "i915.enable_guc=0"
  ];
  # boot.extraModprobeConfig = "options i916 enable_gvt=1";
  virtualisation.kvmgt.enable = true;
  # virtualisation.kvmgt.vgpus = {
  #   "i915-GVTg_V5_4" = { uuid = [ "a297db4a-f4c2-11e6-90f6-d3b88d6c9525" ]; };
  # };
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';

  hardware.cpu.intel.updateMicrocode = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable sound.
  musnix.enable = true;
  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "nofile";
      type = "soft";
      value = "999999";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "hard";
      value = "999999";
    }
  ];

  virtualisation.libvirtd.enable = true;

  # More hardware info
  services.ratbagd.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="0a87", GROUP="audio"
  ''
    # + builtins.replaceStrings [ "/bin/chmod" ] [ "${pkgs.coreutils}/bin/chmod" ]
    #   (builtins.readFile openrgb-rules)
  ;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    dmidecode
    i2c-tools
    # openrgb
    parted
    pciutils
    usbutils
  ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 1234 3000 8000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  programs.adb.enable = true;

  system.autoUpgrade.enable = true;

  # Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # Don't change this.
  system.stateVersion = "20.09"; # Did you read the comment?

  networking.extraHosts = "127.0.0.1 casa.taglialegne.it";
}
