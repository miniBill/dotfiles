{ config, pkgs, agenix, ... }:

{
  imports = [
    agenix.nixosModules.default
  ];

  age.secrets.tailscale = {
    file = ../secrets/tailscale.age;
    owner = "root";
    group = "root";
  };

  # Boot
  boot.tmp.cleanOnBoot = true;

  # Networking
  networking = {
    networkmanager.enable = true; # Enables NetworkManager
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;

    domain = "taglialegne.it";

    # Strict reverse path check can break tailscale exit nodes
    firewall.checkReversePath = "loose";
    firewall.trustedInterfaces = [ "tailscale0" ];
    firewall.allowedUDPPorts = [ config.services.tailscale.port ];

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  # Common software
  environment.systemPackages = with pkgs; [
    # Core
    vim

    # Sysadmining
    agenix.packages."${system}".default
    gdu
    htop
    lsof
    screen
    sysstat
    tmux
    tcpdump
    ethtool
    socat
    smartmontools
    nh

    # Network
    nmap
    wget
    tailscale

    # Misc
    acpitool
    exfat
    git
    ntfs3g
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.ssh = {
    startAgent = true;

    ciphers = [
      "chacha20-poly1305@openssh.com"
      "aes256-gcm@openssh.com"
      "aes128-gcm@openssh.com"
      "aes256-ctr"
      "aes192-ctr"
      "aes128-ctr"
    ];
    kexAlgorithms = [
      "sntrup761x25519-sha512@openssh.com"
      "curve25519-sha256"
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group16-sha512"
      "diffie-hellman-group18-sha512"
      "diffie-hellman-group-exchange-sha256"
    ];
    macs = [
      "hmac-sha2-256-etm@openssh.com"
      "hmac-sha2-512-etm@openssh.com"
      "umac-128-etm@openssh.com"
    ];
    hostKeyAlgorithms = [
      "sk-ssh-ed25519-cert-v01@openssh.com"
      "ssh-ed25519-cert-v01@openssh.com"
      "sk-ssh-ed25519@openssh.com"
      "ssh-ed25519"
      "rsa-sha2-512-cert-v01@openssh.com"
      "rsa-sha2-256-cert-v01@openssh.com"
      "rsa-sha2-512"
      "rsa-sha2-256"
    ];
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
  };

  # Services
  services.openssh = {
    enable = true;
    settings.UseDns = false;
  };
  services.hardware.bolt.enable = true;

  # Services - Tailscale
  services.tailscale.enable = true;
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
      ${tailscale}/bin/tailscale up -authkey file:${config.age.secrets.tailscale.path}
    '';
  };

  services.fwupd.enable = true;

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

      extra-substituters = "https://devenv.cachix.org";
      extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    };
    package = pkgs.nixFlakes;
  };

  # Users
  users.users.minibill = {
    isNormalUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGAVCUqG9wVONKAUB449Zn+B/6nbKPFOlCcyCC55u3K minibill@uriel"
    ];
    extraGroups = [ "wheel" ];
  };
}
