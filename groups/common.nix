{ config, pkgs, agenix, ... }:

let
  tailscale-key = import ../keys/tailscale.nix;
in

{
  imports = [
    agenix.nixosModules.default
  ];

  # Boot
  boot.cleanTmpDir = true;

  # Networking
  networking.networkmanager.enable = true; # Enables NetworkManager
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  # Strict reverse path check can break tailscale exit nodes
  networking.firewall.checkReversePath = "loose";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "it_IT.UTF-8";
    extraLocaleSettings = {
      LANG = "en_GB.UTF-8";
    };
    inputMethod.enabled = "ibus";
    supportedLocales = [
      "en_GB.UTF-8/UTF-8"
      "it_IT.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  # Common software
  environment.systemPackages = with pkgs; [
    acpitool
    exfat
    gdu
    git
    htop
    agenix.packages."${system}".default
    lsof
    ncdu
    ntfs3g
    screen
    sysstat
    tailscale
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
  services.openssh.forwardX11 = true;
  services.tailscale.enable = true;
  services.hardware.bolt.enable = true;
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey ${tailscale-key}
    '';
  };


  # Nix
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    package = pkgs.nixFlakes;
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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGAVCUqG9wVONKAUB449Zn+B/6nbKPFOlCcyCC55u3K minibill@uriel"
    ];
  };
  users.groups.audio = { };
}
