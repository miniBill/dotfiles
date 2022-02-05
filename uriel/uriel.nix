# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

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
      ./hardware-configuration.nix
      <musnix>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.blacklistedKernelModules = [ "snd_hda_codec_hdmi" ];

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

  # Used by vscode, parcel and friends
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;
  };
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

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "uriel"; # Define your hostname.
  networking.networkmanager.enable = true; # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlo1.useDHCP = false;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = "ibus";
  };
  console = {
    useXkbConfig = true;
  };

  time.timeZone = "Europe/Rome";

  hardware.cpu.intel.updateMicrocode = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # 32-bit support for Steam
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  programs.steam.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio = {
  #   enable = true;
  #   support32Bit = true; # Needed for Steam
  #   extraModules = [ pkgs.pulseaudio-modules-bt ];
  #   package = pkgs.pulseaudioFull;
  # };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    package = pinned-unstable.pipewire;
  };
  musnix.enable = true;
  security.pam.loginLimits = [
    { domain = "@audio"; item = "nofile"; type = "soft"; value = "999999"; }
    { domain = "@audio"; item = "nofile"; type = "hard"; value = "999999"; }
  ];

  # More hardware info
  # hardware.keyboard.zsa.enable = true; # one day...
  services.blueman.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="zsa"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="df11", GROUP="zsa"
    SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="0a87", GROUP="audio"
  '' + builtins.replaceStrings [ "/bin/chmod" ] [ "${pkgs.coreutils}/bin/chmod" ] (builtins.readFile openrgb-rules);
  virtualisation.libvirtd.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
  };
  programs.adb.enable = true;

  users.groups.zsa = { };

  users.users.minibill = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" "adbusers" "zsa" "video" "plugdev" "libvirtd" "audio" ];
  };
  users.groups.audio = { };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    lsof
    sysstat
    ncdu
    gparted
    ntfs3g
    parted
    exfat
    acpitool
    pciutils
    tmux
    screen
    vim
    wget
    tailscale
    kwin
    openrgb
    usbutils
    i2c-tools
    dmidecode
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedTCPPorts = [ 1234 3000 8000 ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  services.tailscale.enable = true;

  system.autoUpgrade.enable = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    autoOptimiseStore = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
