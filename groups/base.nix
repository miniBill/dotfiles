{ pkgs, config, username, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  onLinux = x: if isDarwin then [ ] else x;

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
  ] ++ onLinux [
    inotify-tools
    smem
  ];

  # Dev
  packages-dev = with pkgs; [
    git
    gnumake
  ] ++ onLinux [
    tup
  ];

  # Net
  packages-net-analysis = with pkgs; [
    mtr
    nmap
    whois
  ] ++ onLinux [
    bmon
    dnsutils
  ];

  packages-net-misc = with pkgs; [
    aria
    jq
    openssl
  ];

  packages-net = packages-net-analysis ++ packages-net-misc;

  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

  pnpm-home = homeDirectory + "/.local/share/pnpm";
in
{
  home = {
    packages =
      packages-base ++ packages-dev ++ packages-net;

    file = {
      ".zsh/p10k.zsh".source = ../files/zsh/p10k.zsh;
      ".cargo/config.toml".source = ../files/cargo/config.toml;
    };

    sessionPath = [
      "$HOME/bin"
      ("${homeDirectory}/.volta/bin")
      pnpm-home
    ];

    language.base = "en_US.UTF-8";

    username = username;
    homeDirectory = homeDirectory;

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

  systemd.user.tmpfiles.rules = onLinux [
    ("d ${homeDirectory}/.ssh/control 700 ${username} users")
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fzf.enable = true;

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
      };
    };

    tmux = {
      enable = true;
      newSession = true;
      extraConfig = "set-option -g mouse on";
      terminal = "xterm-256color";
    };

    yt-dlp.enable = true;

    zsh = {
      enable = true;

      autocd = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableVteIntegration = !isDarwin;

      history = {
        expireDuplicatesFirst = true;
        ignoreSpace = true;
        path = "${config.xdg.stateHome}/zsh/history";
      };

      initExtra =
        if isDarwin then
          ''
            export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels''${NIX_PATH:+:$NIX_PATH}
            
            autopair-init
            source ~/.zsh/p10k.zsh
          ''
        else
          ''
            autopair-init
            source ~/.zsh/p10k.zsh
          '';

      oh-my-zsh = {
        enable = true;
        plugins = [ "command-not-found" "git" "history" "ssh-agent" "sudo" "tmux" ];
      };

      plugins = with pkgs; [
        {
          name = "zsh-syntax-highlighting";
          src = fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.6.0";
            sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
          };
          file = "zsh-syntax-highlighting.zsh";
        }
        {
          name = "zsh-aws-vault";
          src = fetchFromGitHub
            {
              owner = "blimmer";
              repo = "zsh-aws-vault";
              rev = "818fc96a73512dd86bfcad850c430e974fd53d78";
              sha256 = "sha256-WuzBwfIOmENQpo94r9+h2E0OEzs1bGNbLy/D2izK+Qw=";
            };
        }
        {
          name = "zsh-autopair";
          src = fetchFromGitHub {
            owner = "hlissner";
            repo = "zsh-autopair";
            rev = "34a8bca0c18fcf3ab1561caef9790abffc1d3d49";
            sha256 = "1h0vm2dgrmb8i2pvsgis3lshc5b0ad846836m62y8h3rdb3zmpy1";
          };
          file = "autopair.zsh";
        }
        {
          name = "powerlevel10k";
          file = "powerlevel10k.zsh-theme";
          src = fetchFromGitHub {
            owner = "romkatv";
            repo = "powerlevel10k";
            rev = "8d1daa4e6340b1689bf951730489bc64c52220c7";
            sha256 = "0bm0dd4lb9kwv3xl6lk0wyb0fqq83gs8kl9111qs5ybavwcxlnnr";
          };
        }
        {
          name = "nix-shell";
          src = fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "IT3wpfw8zhiNQsrw59lbSWYh0NQ1CUdUtFzRzHlURH0=";
          };
        }
      ];

      sessionVariables = {
        EDITOR = "vim";
        TERM = "xterm-256color";
        DOTNET_CLI_TELEMETRY_OPTOUT = "1";
        PNPM_HOME = pnpm-home;
        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
        VOLTA_HOME = homeDirectory + "/.volta";
      };

      shellAliases = {
        open = "xdg-open";
      };
    };
  };
}
