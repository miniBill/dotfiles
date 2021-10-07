{ config, pkgs, ... }:
let
  pinned-unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/4ad4ae68c427ef8458be34051b4e545eb752811c.tar.gz") { };
  # pinned-oldstable = pkgs.callPackage ./nixpkgs-9518fac712ca001009bd12a3c94621f1ee805657/default.nix {
  #   config = {
  #     allowUnfree = true;
  #     chromium = {
  #       enablePepperFlash = true;
  #     };
  #   };
  # };

  # polychromatic = pkgs.python3Packages.callPackage ./polychromatic.nix pkgs;
in
{
  imports = [ ./machine-common.nix ];

  home.packages = with pkgs; [
    # BASE
    file
    unzip
    nix-bundle
    exa
    bc
    patchelf
    inotify-tools
    (callPackage ./programs/wally-cli.nix { })
    neofetch
    pigz
    usbutils
    smem
    (aspellWithDicts (d: [ d.it ]))
    # openrgb polychromatic

    # DEV
    colordiff
    git
    gnumake
    gitAndTools.qgit
    # Elm
    elmPackages.elm-format
    elmPackages.elm
    elmPackages.elm-test
    elmPackages.elm-json
    elmPackages.elm-live
    optipng
    yarn
    nodejs
    (callPackage ./programs/lamdera.nix { })
    # .NET
    (with dotnetCorePackages; combinePackages [ sdk_3_1 ])
    omnisharp-roslyn # dotnet-sdk
    # zig sqlitebrowser
    # Java
    adoptopenjdk-jre-openj9-bin-8 # jre
    # pkgsi686Linux.openjdk8
    # C/C++
    qtcreator
    cmake
    clang-tools
    cppcheck
    gcc
    gdb
    linuxPackages.perf
    hotspot
    # Rust
    rustc
    cargo
    # GLSL
    glslang
    # Misc
    ghc
    (python38.withPackages (ps: with ps; [ black ]))
    # binutils nasm
    # Dhall
    # dhall-lsp-server dhall

    # NET
    filezilla
    nmap
    ncat
    bind
    whois
    pinned-unstable.youtubeDL
    aria
    zotero
    bmon
    dnsutils
    jq
    mtr
    google-chrome
    (keepass.override { plugins = [ keepass-keepassrpc ]; })
    irssi
    # Im
    pinned-unstable.zoom-us
    discord
    teams
    skypeforlinux
    tdesktop

    # GUI
    ark
    yakuake
    kcharselect
    kcalc
    gnome3.libgnomekbd
    libsForQt5.spectacle
    gparted
    libreoffice-fresh
    xclip
    pinned-unstable.dbeaver
    etcher
    calibre
    # Wine
    winetricks
    wineWowPackages.stable
    # Multimedia
    gimp
    spotify
    inkscape
    okular
    ghostscript
    scribusUnstable
    blender
    glxinfo
    vlc
    imagemagick
    ffmpeg
    mediainfo
    qjackctl
    gnome3.cheese
    audacity
    clementine
    gwenview
    kolourpaint
    pinned-unstable.helvum
    carla
    pulseaudio
    # Fonts
    pinned-unstable.fira-code
    pinned-unstable.fira-code-symbols
    (callPackage ./linja-pona.nix { })

    # GAMES
    steam
    (steam.override {
      withPrimus = true;
      extraPkgs = pkgs: with pkgs; [
        nettools
        glxinfo
        mono
        gtk3
        gtk3-x11
        libgdiplus
        zlib
      ];
      nativeOnly = true;
    }).run
    mupen64plus
    wxmupen64plus
    lutris-free
    mgba

    # VIRT/OP
    # nixops
    virtmanager
    nix-index
    virtualbox
    qemu
  ];

  home.file = {
    ".alsoftrc".source = ./files/alsoftrc;
    ".mozilla/firefox/u3snpikq.default/chrome/userChrome.css".text = ''
      #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar > .toolbar-items {
        opacity: 0;
        pointer-events: none;
      }
      #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
          visibility: collapse !important;
      }'';

    # Old version of chrome that still supports flash
    # "Applications/old-chromium".source = pinned-oldstable.chromium;
    # ".config/chromium/Default/Pepper Data/Shockwave Flash/System/mms.cfg".source = ./files/mms.cfg;
  };

  programs = {
    htop = {
      enable = true;
      settings.hide_userland_threads = true;
    };

    obs-studio.enable = true;

    vscode = {
      enable = true;
      package = pinned-unstable.vscode;
    };

    zsh = {
      initExtra = ''
        autopair-init
        source ~/.p10k.zsh
      '';
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  nixpkgs.overlays = [
    (self: super: {
      obs-studio = pinned-unstable.obs-studio;
    })
  ];

  home.username = "minibill";
  home.homeDirectory = "/home/minibill";
  home.language.base = "it_IT.UTF-8";
}
