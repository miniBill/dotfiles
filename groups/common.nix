{ config, pkgs, ... }:

{
  # Boot
  boot.cleanTmpDir = true;

  # Networking
  networking.networkmanager.enable = true; # Enables NetworkManager
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = "ibus";
  };

  # Common software
  environment.systemPackages = with pkgs; [
    acpitool
    exfat
    git
    htop
    lsof
    ncdu
    ntfs3g
    screen
    sysstat
    tmux
    vim
    wget
    zsh
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.ssh.startAgent = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
  };

  # Services
  services.openssh.enable = true;

  # Nix
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    autoOptimiseStore = true;
  };

  # Users
  users.users.minibill = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "adbusers"
      "video"
      "plugdev"
      "libvirtd"
      "audio"
    ];
  };
  users.groups.audio = { };
}
