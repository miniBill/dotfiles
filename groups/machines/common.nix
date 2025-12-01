{
  config,
  pkgs,
  lib,
  # , nixpkgs-small
  agenix,
  ...
}:

{
  imports = [
    agenix.nixosModules.default
  ];

  age.secrets.tailscale = {
    file = ../../secrets/tailscale.age;
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
    firewall.trustedInterfaces = [ "tailscale0" ];

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
    btop
    lsof
    screen
    sysstat
    tmux
    tcpdump
    ethtool
    socat
    smartmontools
    pciutils
    usbutils
    parted

    # Network
    nmap
    wget
    tailscale

    # Misc
    acpitool
    exfat
    git
    ntfs3g
    p7zip
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 14d";
    };
  };

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
    # package = nixpkgs-small.legacyPackages."${pkgs.system}".openssh;
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
  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = config.age.secrets.tailscale.path;
  };
  systemd.services.tailscaled-autoconnect.wantedBy = lib.mkForce [ ];

  services.fwupd.enable = true;

  # Nix
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
        # "repl-flake"
      ];

      # extra-substituters = "https://devenv.cachix.org";
      # extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    };

    package = pkgs.lixPackageSets.stable.lix;
  };

  nixpkgs.overlays = [
    (final: prev: {
      inherit (final.lixPackageSets.stable)
        nixpkgs-review
        nix-direnv
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];

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
