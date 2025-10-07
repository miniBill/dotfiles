{ nixos-hardware
, config
, pkgs
, musnix
, lib
, ...
}:

{
  imports = [
    nixos-hardware.nixosModules.framework-amd-ai-300-series
    ./hardware-configuration.nix
    musnix.nixosModules.musnix
    ../../groups/machines/common.nix
    ../../groups/machines/graphical.nix
    ../../groups/machines/steam.nix
    ../../groups/machines/plymouth.nix
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_6_16;

  networking.hostName = "nathanda";
  networking.interfaces.wlp192s0.useDHCP = false;

  # boot.kernelParams = [ ];
  # boot.extraModprobeConfig = "";
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';

  hardware.cpu.amd.updateMicrocode = true;

  hardware.graphics.enable = true;

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
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # More hardware info
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="0a87", GROUP="audio"
  '';

  # environment.systemPackages = with pkgs; [ ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  # age.secrets.snizzovpn = {
  #   file = ../../secrets/snizzovpn.age;
  #   owner = "root";
  #   group = "root";
  # };
  # services.openvpn.servers = {
  #   snizzoVPN = {
  #     config = ''config ${config.age.secrets.snizzovpn.path}'';
  #   };
  # };

  programs.adb.enable = true;

  # Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  users.users.gabriel = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" ];
  };

  system.stateVersion = "25.05";
}
