# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  pinned-unstable = import ./pinned-unstable.nix;
  openrgb-rules = builtins.fetchurl {
    url = "https://gitlab.com/CalcProgrammer1/OpenRGB/-/raw/master/60-openrgb.rules";
  };

in
{
  imports =
    [
      # Include the results of the hardware scan.
      ../hardware-configuration.nix
      <musnix>
      ../groups/common.nix
      ../groups/graphical.nix
      ./web.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    mirroredBoots = [
      {
        devices = [ "nodev" ];
        path = "/boot-fallback";
      }
    ];
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

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
  #boot.kernelPatches = [
  #  {
  #    name = "OpenRGB patch";
  #    patch = builtins.fetchurl "https://gitlab.com/CalcProgrammer1/OpenRGB/-/raw/0c45e26c98d5501ea7e575172e302b3109b3c7f5/OpenRGB.patch";
  #  }
  #];
  # boot.kernelPackages = pkgs.linuxPackages_5_12;

  boot.kernelParams = [
    "intel_iommu=on"
    # "i915.enable_guc=0"
  ];
  # boot.extraModprobeConfig = "options i916 enable_gvt=1";
  virtualisation.kvmgt.enable = true;
  virtualisation.kvmgt.vgpus = {
    "i915-GVTg_V5_4" = {
      uuid = [ "a297db4a-f4c2-11e6-90f6-d3b88d6c9525" ];
    };
  };
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';

  hardware.cpu.intel.updateMicrocode = true;

  # 32-bit support for Steam
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  programs.steam.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  services.pipewire.package = pinned-unstable.pipewire;
  musnix.enable = true;
  security.pam.loginLimits = [
    { domain = "@audio"; item = "nofile"; type = "soft"; value = "999999"; }
    { domain = "@audio"; item = "nofile"; type = "hard"; value = "999999"; }
  ];

  virtualisation.libvirtd.enable = true;

  # More hardware info
  services.blueman.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="0a87", GROUP="audio"
  '' + builtins.replaceStrings [ "/bin/chmod" ] [ "${pkgs.coreutils}/bin/chmod" ] (builtins.readFile openrgb-rules);

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpitool
    dmidecode
    exfat
    gparted
    i2c-tools
    kwin
    ntfs3g
    openrgb
    parted
    pciutils
    sysstat
    tailscale
    usbutils
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedTCPPorts = [ 1234 3000 8000 ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  services.tailscale.enable = true;

  programs.adb.enable = true;

  system.autoUpgrade.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
