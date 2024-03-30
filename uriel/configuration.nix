{ config, pkgs, musnix, lib, ... }:

let
  # openrgb-rules = builtins.fetchurl {
  #   url =
  #     "https://gitlab.com/CalcProgrammer1/OpenRGB/-/raw/master/60-openrgb.rules";
  # };
  killingFloorTCPPorts = [ 28852 8075 20560 ];
  kilingFloorUDPPorts = [ 28852 20560 7707 7708 7717 ];
in
{
  imports = [
    ./hardware-configuration.nix
    musnix.nixosModules.musnix
    ../groups/common.nix
    ../groups/graphical.nix
    ../groups/steam.nix
    # ./web.nix
    # ./ups.nix
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

  networking.hostName = "uriel";
  networking.interfaces.wlo1.useDHCP = false;

  boot.kernelPackages = pkgs.linuxPackages_6_6;
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
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

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
  networking.firewall.allowedTCPPorts = [
    80
    8000
    1234
    # Minecraft
    25565
  ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.interfaces.tun0 =
    {
      allowedTCPPorts = killingFloorTCPPorts;
      allowedUDPPorts = kilingFloorUDPPorts;
    };

  age.secrets.snizzovpn = {
    file = ../secrets/snizzovpn.age;
    owner = "root";
    group = "root";
  };
  services.openvpn.servers = {
    snizzoVPN = { config = ''config ${config.age.secrets.snizzovpn.path}''; };
  };

  programs.adb.enable = true;

  # Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  system.stateVersion = "22.05";

  networking.extraHosts = "127.0.0.1 casa.taglialegne.it";
}
