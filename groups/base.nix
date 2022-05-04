{ pkgs, ... }:
let
  # Base
  packages-base = with pkgs; [
    bc
    file
    inotify-tools
    moreutils
    openssh
    patchelf
    pigz
    ripgrep
    smem
    unzip
  ];

  # Dev
  packages-dev = with pkgs; [
    git
    gnumake
  ];

  # Net
  packages-net-analysis = with pkgs; [
    bmon
    dnsutils
    mtr
    ncat
    nmap
    whois
  ];

  packages-net-misc = with pkgs; [
    aria
    jq
    openssl
  ];

  packages-net = packages-net-analysis ++ packages-net-misc;

  pnpm-home = "/home/minibill/.local/share/pnpm";
in
{
  home = {
    packages =
      packages-base ++ packages-dev ++ packages-net;

    file = {
      ".p10k.zsh".source = ../files/p10k.zsh;
      ".cargo/config.toml".source = ../files/cargo/config.toml;
    };

    sessionPath = [
      "$HOME/bin"
      pnpm-home
    ];

    language.base = "en_US.UTF-8";

    username = "minibill";
    homeDirectory = "/home/minibill";

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

  systemd.user.tmpfiles.rules = [
    "d /home/minibill/.ssh/control 700 minibill users"
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
      };
    };

    tmux = {
      enable = true;
      newSession = true;
      extraConfig = "set-option -g mouse on";
      terminal = "xterm-256color";
    };

    zsh = {
      enable = true;

      autocd = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableVteIntegration = true;

      history = {
        expireDuplicatesFirst = true;
        ignoreSpace = true;
      };

      initExtra = ''
        autopair-init
        source ~/.p10k.zsh
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
            rev = "03a1487655c96a17c00e8c81efdd8555829715f8";
            sha256 = "1avnmkjh0zh6wmm87njprna1zy4fb7cpzcp8q7y03nw3aq22q4ms";
          };
        }
      ];

      sessionVariables = {
        EDITOR = "vim";
        TERM = "xterm-256color";
        DOTNET_CLI_TELEMETRY_OPTOUT = "1";
        PNPM_HOME = pnpm-home;
      };

      shellAliases = {
        open = "xdg-open";
      };
    };
  };
}
