# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
../groups/common.nix
    ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Mirror GRUB on the two disks
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    mirroredBoots = [
      { devices = [ "nodev" ];
        path = "/boot-fallback";
      }
    ];
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;
  };

  nixpkgs.config.allowUnfree = true;

  systemd.services.fixgpe13 = {
    description = "Disable interrupt GPE13 to avoid CPU abuse";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = "grep -q disabled /sys/firmware/acpi/interrupts/gpe13 || echo disable > /sys/firmware/acpi/interrupts/gpe13";
  };

  networking.hostName = "edge"; # Define your hostname.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = false;
  networking.interfaces.wlp4s0.useDHCP = false;

  # Select internationalisation properties.
  i18n = {
    inputMethod = {
      enabled = "ibus";
    };
  };

  time.timeZone = "Europe/Rome";

  environment.systemPackages = with pkgs; [
    lsof sysstat ncdu gparted ntfs3g parted exfat
    acpitool
    tmux screen
    vim
    wget
    kwin yakuake pavucontrol
    nvidia-offload
  ];

  # 32-bit support for Steam
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  ############
  # SERVICES #
  ############
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 8000 1234 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # hardware.keyboard.zsa.enable = true; # one day...
  services.blueman.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="zsa"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="df11", GROUP="zsa"
  '';

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "it";
    # xkbOptions = "eurosign:e";

    # Enable touchpad support.
    libinput.enable = true;

    # Enable the KDE Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;

    # videoDrivers = [ "modesetting" "nvidia" "intel" ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable= true;
  };
  programs.adb.enable = true;

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.zsa = {};

  users.users.minibill = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "adbusers" "zsa" "video" ];
  };

  users.users.rstor = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  system.autoUpgrade.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    autoOptimiseStore = true;
  };
}

