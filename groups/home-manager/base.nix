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
      b3sum

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
      nixfmt
      alejandra
      uv
      jujutsu
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
    aria2
    jq
    openssl
  ];

  packages-net = packages-net-analysis ++ packages-net-misc;

  homeDirectory = if stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  imports = [
    ./zsh
    nix-index-database.homeModules.nix-index
  ];

  xdg.configFile = {
    "nix/nix.conf".source = ./files/nix.conf;
    "Code/Dictionaries".source =
      config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/.nix-profile/share/hunspell";
  };
  xdg.dataFile."cargo/config.toml".source = ./files/cargo/config.toml;

  home = {
    packages = packages-base ++ packages-dev ++ packages-net;

    file = {
      "bin/lamdera-1.3.2-no-wire".source = ./files/lamdera-no-wire;
      "bin/lamdera-1.4.0-no-wire".source = ./files/lamdera-no-wire;
      "bin/lamdera-next-no-wire".source = ./files/lamdera-no-wire;
      "bin/elm-format-hack".source = ./files/elm-format-hack;
      "bin/elm-make-readable".source = ./files/elm-make-readable;
      "bin/lamdera-wrapped" = lib.mkIf stdenv.isDarwin { source = ./files/lamdera-wrapped; };

      ".npmrc".source = ./files/npmrc;
      # ".yarnrc".source = ./files/yarnrc;
    };

    sessionPath = [
      "$HOME/.bun/bin"
      "$HOME/bin"
    ];

    language.base = lib.mkDefault "en_US.UTF-8";

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
      withPython3 = false;
      withRuby = false;
      extraConfig = ''
        set number
        set relativenumber
      '';
      initLua = ''
        require("hardtime").setup()
      '';
      plugins = with pkgs.vimPlugins; [
        hardtime-nvim
      ];
    };

    delta.enable = true;

    difftastic = {
      enable = true;
      git.enable = true;
    };

    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user.name = "Leonardo Taglialegne";
        user.email = lib.mkDefault "leonardo@taglialegne.it";

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

    jujutsu = {
      enable = false;
      settings = {
        user = {
          email = "leonardo@taglialegne.it";
          name = "Leonardo Taglialegne";
        };
      };
    };

    home-manager.enable = true;

    nix-index.enable = true;
    nix-index-database.comma.enable = true;

    htop = {
      enable = true;
      settings.hide_userland_threads = true;
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "*" = {
          ControlMaster = "auto";
          ControlPath = "~/.ssh/control/%r@%h:%p";
          ControlPersist = "10m";
        };
        "tharmas" = {
          HostName = "tharmas.taglialegne.it";
        };
        "uriel" = {
          HostName = "100.69.168.4";
        };
        "edge" = {
          HostName = "100.108.17.9";
        };
        "lamdera-ambue" = {
          HostName = "ambue-enterprise.lamdera.com";
          IdentityFile = "~/.ssh/id_ed25519_ci_ambue";
          IdentitiesOnly = true;
        };
        "git.aljordan.dev" = {
          Port = 2233;
        };
        "wrap" = {
          User = "miniBill";
          HostName = "51.159.120.131";
        };
        "roiter" = {
          HostName = "10.0.255.254";
          User = "admin";
          ProxyJump = "uriel";
          HostKeyAlgorithms = "+ecdsa-sha2-nistp521";
          MACs = "+hmac-sha2-256";
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

    zellij.enable = true;

    zoxide.enable = true;
  };
}
