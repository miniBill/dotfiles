{ config, pkgs, ... }:
let
  pinned-unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/4ad4ae68c427ef8458be34051b4e545eb752811c.tar.gz") { };
in
{
  imports = [ ./machine-common.nix ];

  home.packages = with pkgs; [
    # BASE
    # openrgb (pkgs.python3Packages.callPackage ./polychromatic.nix pkgs)

    # GUI
    calibre
    gnome3.libgnomekbd
    gparted
    libreoffice-fresh
    # Wine
    winetricks
    wineWowPackages.stable
    # Multimedia
    audacity
    blender
    carla
    clementine
    ghostscript
    glxinfo
    gnome3.cheese
    inkscape
    mediainfo
    pinned-unstable.helvum
    pulseaudio
    qjackctl

    # DEV
    colordiff
    # .NET
    # (with dotnetCorePackages; combinePackages [ sdk_3_1 ])
    # omnisharp-roslyn dotnet-sdk
    # Java
    adoptopenjdk-jre-openj9-bin-8 # jre
    # pkgsi686Linux.openjdk8
    # C/C++
    clang-tools
    cmake
    cppcheck
    hotspot
    linuxPackages.perf
    qtcreator
    # Rust
    rustc
    cargo
    # GLSL
    glslang
    # Misc
    ghc
    # zig sqlitebrowser binutils nasm

    # NET
    (keepass.override { plugins = [ keepass-keepassrpc ]; })
    bind
    google-chrome
    irssi
    pinned-unstable.youtubeDL
    zotero
    # Im
    discord
    teams
    skypeforlinux
    tdesktop

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
    ".mozilla/firefox/u3snpikq.default/chrome/userChrome.css".source = ./files/userChrome.css;

    # Old version of chrome that still supports flash
    # pinned-oldstable = pkgs.callPackage ./nixpkgs-9518fac712ca001009bd12a3c94621f1ee805657/default.nix {
    #   config = {
    #     allowUnfree = true;
    #     chromium = {
    #       enablePepperFlash = true;
    #     };
    #   };
    # };
    # "Applications/old-chromium".source = pinned-oldstable.chromium;
    # ".config/chromium/Default/Pepper Data/Shockwave Flash/System/mms.cfg".source = ./files/mms.cfg;
  };

  programs = {
    obs-studio.enable = true;

    zsh.initExtra = ''
      autopair-init
      source ~/.p10k.zsh
    '';
  };

  nixpkgs.overlays = [
    (self: super: {
      obs-studio = pinned-unstable.obs-studio;
    })
  ];
}
