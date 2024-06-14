{ pkgs, lib, config, username, ... }:
let
  inherit (pkgs) stdenv;

  # Base
  packages-base = with pkgs; [
    bc
    file
    moreutils
    openssh
    patchelf
    pigz
    ripgrep
    zip
    unzip
    comma
  ] ++ lib.optionals stdenv.isLinux [
    inotify-tools
    smem
  ];

  # Dev
  packages-dev = with pkgs; [
    gnumake
  ] ++ lib.optionals stdenv.isLinux [
    tup
  ];

  # Net
  packages-net-analysis = with pkgs; [
    mtr
    nmap
  ] ++ lib.optionals stdenv.isLinux [
    bmon
    dnsutils
    whois
  ];

  packages-net-misc = with pkgs; [
    aria
    jq
    openssl
  ];

  packages-net = packages-net-analysis ++ packages-net-misc;

  homeDirectory = if stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  imports = [ ../programs/zsh.nix ];

  home = {
    packages =
      packages-base ++ packages-dev ++ packages-net;

    file = {
      ".zsh/p10k.zsh".source = ../files/zsh/p10k.zsh;
      ".cargo/config.toml".source = ../files/cargo/config.toml;
      ".elm".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/elm";
      ".config/nix/nix.conf".source = ../files/nix.conf;
    };

    sessionPath = [
      "$HOME/bin"
    ];

    language.base = "en_US.UTF-8";

    inherit username homeDirectory;

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "21.11";
  };

  systemd.user.tmpfiles.rules = lib.optionals stdenv.isLinux [
    "d ${homeDirectory}/.ssh/control 700 ${username} users"
  ];

  programs = {
    bash = {
      enable = true;
      historyFile = "${config.xdg.stateHome}/bash/history";
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fzf.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
      delta.enable = true;
      userName = "Leonardo Taglialegne";
      userEmail = lib.mkDefault "cmt.miniBill@gmail.com";
      extraConfig = {
        advice.detachedHead = "false";
        branch.sort = "-committerdate";
        core.editor = "vim";
        diff.algorithm = "histogram";
        fetch.prune = true;
        fetch.parallel = 0;
        gpg.format = "ssh";
        help.autocorrect = 10;
        init.defaultBranch = "main";
        merge.conflictstyle = "zdiff3";
        pull.rebase = "true";
        push.autoSetupRemote = "true";
        rerere.enabled = true;
        url."git@github.com:".insteadOf = "gh:";

        rebase.autosquash = true;
        rebase.autostash = true;
        rebase.updateRefs = true;

        transfer.fsckobjects = true;
        fetch.fsckobjects = true;
        receive.fsckObjects = true;

        status.submoduleSummary = true;
        diff.submodule = "log";
        submodule.recurse = true;

        safe.directory = "/etc/nixos";
      };
    };

    home-manager.enable = true;

    htop = {
      enable = true;
      settings.hide_userland_threads = true;
    };

    ssh = {
      enable = true;
      controlMaster = "auto";
      controlPath = "~/.ssh/control/%r@%h:%p";
      controlPersist = "10m";

      matchBlocks = {
        "tharmas" = {
          hostname = "tharmas.taglialegne.it";
        };
        "uriel" = {
          hostname = "100.69.168.4";
        };
        "edge" = {
          hostname = "100.108.17.9";
        };
        "lamdera-ambue" = {
          hostname = "apps.lamdera.com";
          identityFile = "~/.ssh/id_ed25519_ci_ambue";
          identitiesOnly = true;
        };
        "ambue-enterprise.lamdera.com" = {
          identityFile = "~/.ssh/id_ed25519_ci_ambue";
          identitiesOnly = true;
        };
      };
    };

    tmux = {
      enable = true;
      newSession = true;
      extraConfig = "set-option -g mouse on";
      terminal = "xterm-256color";
    };

    yt-dlp.enable = true;
  };
}
