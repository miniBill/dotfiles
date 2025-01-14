{ pkgs, config, ... }:

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
  imports = [
    ./hardware-configuration.nix
    ../../groups/machines/common.nix
    ../../groups/machines/graphical.nix
    ../../groups/machines/steam.nix
  ];

  # Mirror GRUB on the two disks
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    mirroredBoots = [{
      devices = [ "nodev" ];
      path = "/boot-fallback";
    }];
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = false;

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  networking.hostName = "edge";
  networking.interfaces.enp5s0.useDHCP = false;
  networking.interfaces.wlp4s0.useDHCP = false;

  systemd.services.fixgpe13 = {
    description = "Disable interrupt GPE13 to avoid CPU abuse";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = "grep -q disabled /sys/firmware/acpi/interrupts/gpe13 || echo disable > /sys/firmware/acpi/interrupts/gpe13";
  };

  environment.systemPackages = with pkgs; [
    nvidia-offload
  ];

  networking.firewall.allowedTCPPorts = [ 80 8000 1234 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    xkb.layout = "it";
    # videoDrivers = [ "modesetting" "nvidia" "intel" ];
  };

  services.libinput.enable = true;

  programs.adb.enable = true;

  virtualisation.docker.enable = true;

  users.users.rstor = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };
  users.users.francesca = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" ];
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    });
  '';

  system.stateVersion = "20.03";
}
