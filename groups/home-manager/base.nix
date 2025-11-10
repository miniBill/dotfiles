{
  pkgs,
  lib,
  config,
  username,
  nix-index-database,
  ...
}:
let
  inherit (pkgs) stdenv;

  # Base
  packages-base =
    with pkgs;
    [
      bc
      file
      moreutils
      openssh
      patchelf
      pigz
      ripgrep
      fd
      bfs
      zip
      unzip
      # comma

      nix-output-monitor
    ]
    ++ lib.optionals stdenv.isLinux [
      inotify-tools
      smem
    ];

  # Dev
  packages-dev =
    with pkgs;
    [
      gnumake
      nixfmt-rfc-style
      alejandra
      uv
    ]
    ++ lib.optionals stdenv.isLinux [
      tup
    ];

  # Net
  packages-net-analysis =
    with pkgs;
    [
      mtr
      nmap
    ]
    ++ lib.optionals stdenv.isLinux [
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
  imports = [
    ../../programs/zsh.nix
    nix-index-database.homeModules.nix-index
  ];

  home = {
    packages = packages-base ++ packages-dev ++ packages-net;

    file = {
      # ".zsh/p10k.zsh".source = ../../files/zsh/p10k.zsh;
      "${config.xdg.dataHome}/cargo/config.toml".source = ../../files/cargo/config.toml;
      ".elm".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/elm";
      ".config/nix/nix.conf".source = ../../files/nix.conf;
      ".config/Code/Dictionaries".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/.nix-profile/share/hunspell";
    }
    // (if stdenv.isDarwin then { } else { "bin/lamdera-wrapped".source = ../../files/lamdera; });

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

    fzf = {
      enable = true;
      defaultCommand = "bfs -type f";
      fileWidgetCommand = "bfs -type f";
      changeDirWidgetCommand = "bfs -type d";
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = ''
        set number
        set relativenumber
      '';
      extraLuaConfig = ''
        require("hardtime").setup()
      '';
      plugins = with pkgs.vimPlugins; [
        hardtime-nvim
      ];
    };

    git = {
      enable = true;
      lfs.enable = true;
      delta.enable = true;
      userName = "Leonardo Taglialegne";
      userEmail = lib.mkDefault "leonardo@taglialegne.it";

      extraConfig = {
        # Misc
        core.editor = "vim";
        gpg.format = "ssh";
        help.autocorrect = 10;
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        advice.detachedHead = "false";

        url."git@github.com:".insteadOf = "gh:";

        # UI tweaks
        branch.sort = "-committerdate";
        column.ui = "auto,dense";
        tag.sort = "version:refname";

        # Better diff
        diff = {
          algorithm = "histogram";
          colorMoved = true;
          renames = true;
          mnemonicPrefix = true;
        };
        merge.conflictstyle = "zdiff3";

        # Better fetching
        fetch = {
          parallel = 0;
          prune = true;
          all = true;
        };

        # Reuse recorder resolution
        rerere = {
          enabled = true;
          autoupdate = true;
        };

        # Better rebase
        rebase = {
          autosquash = true;
          autostash = true;
          updateRefs = true;
        };

        # Fsck more often
        fetch.fsckobjects = true;
        receive.fsckObjects = true;
        transfer.fsckobjects = true;

        # Submodules
        diff.submodule = "log";
        status.submoduleSummary = true;
        submodule.recurse = true;
      };
    };

    home-manager.enable = true;

    nix-index-database.comma.enable = true;

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
          hostname = "ambue-enterprise.lamdera.com";
          identityFile = "~/.ssh/id_ed25519_ci_ambue";
          identitiesOnly = true;
        };
        "git.aljordan.dev" = {
          port = 2233;
        };
        "roiter" = {
          hostname = "10.0.255.254";
          user = "admin";
          proxyJump = "uriel";

          extraOptions = {
            hostKeyAlgorithms = "+ecdsa-sha2-nistp521";
            MACs = "+hmac-sha2-256";
          };
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

    zoxide.enable = true;
  };
}
