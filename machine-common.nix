{ pkgs, ... }:
let
  pinned-unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/4ad4ae68c427ef8458be34051b4e545eb752811c.tar.gz") { };

  # Base
  packages-base = with pkgs; [
    bc
    file
    inotify-tools
    neofetch
    nix-bundle
    nixpkgs-fmt
    patchelf
    pigz
    ripgrep
    smem
    unzip
    usbutils

    (aspellWithDicts (d: [ d.it ]))

    (callPackage ./programs/wally-cli.nix { })
  ];

  # Dev
  packages-dev-c = with pkgs; [
    gcc
    gdb
  ];

  package-dev-elm = with pkgs; [
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-json
    elmPackages.elm-live
    elmPackages.elm-test
    nodejs
    optipng
    yarn

    (callPackage ./programs/lamdera.nix { })
  ];

  package-dev = package-dev-elm ++ (with pkgs; [
    git
    gitAndTools.qgit

    gnumake

    (python38.withPackages (ps: [ ps.black ]))
  ]);

  # GUI
  packages-gui-fonts = with pkgs; [
    fira-code
    fira-code-symbols

    (callPackage ./linja-pona.nix { })
  ];

  packages-gui-kde = with pkgs; [
    ark
    gwenview
    kcalc
    kcharselect
    kolourpaint
    okular
    plasma-browser-integration
    spectacle
    xdg-desktop-portal-kde
    yakuake
  ];

  packages-gui-misc = with pkgs; [
    etcher
    gnome-keyring # For vscode and saving passwords
  ];

  packages-gui-multimedia = with pkgs; [
    ffmpeg
    imagemagick
    gimp
    scribusUnstable
    spotify
    vlc
  ];

  packages-gui =
    packages-gui-fonts
    ++ packages-gui-kde
    ++ packages-gui-misc
    ++ packages-gui-multimedia;

  # Network
  packages-net-analysis = with pkgs;    [
    bmon
    dnsutils
    mtr
    ncat
    nmap
    whois
  ];

  packages-net-communication = with pkgs; [
    pinned-unstable.zoom-us
  ];

  packages-net-misc = with pkgs; [
    aria
    filezilla
    jq
    openssl
  ];

  packages-net =
    packages-net-analysis
    ++ packages-net-communication
    ++ packages-net-misc;
in
{
  fonts.fontconfig.enable = true;

  home = {
    file = {
      ".npmrc".source = ./files/npmrc;
      ".p10k.zsh".source = ./files/p10k.zsh;
    };

    packages =
      packages-base
      ++ package-dev
      ++ packages-gui
      ++ packages-net
    ;

    sessionPath = [
      "$HOME/bin"
      "$HOME/.npm-global/bin"
    ];

    username = "minibill";
    homeDirectory = "/home/minibill";
    language.base = "en_UK.UTF-8";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "20.03";
  };

  programs = {
    chromium.enable = true;

    firefox = {
      enable = true;

      profiles = {
        main = {
          isDefault = true;

          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };

          userChrome = builtins.readFile ./files/userChrome.css;
        };
      };
    };

    fzf.enable = true;

    home-manager.enable = true;

    htop = {
      enable = true;
      settings.hide_userland_threads = true;
    };

    tmux = {
      enable = true;
      newSession = true;
      extraConfig = "set-option -g mouse on";
      terminal = "xterm-256color";
    };

    vscode = {
      enable = true;
      package = pinned-unstable.vscode;
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
      };

      shellAliases = {
        open = "xdg-open";
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
}
