{ config, pkgs, ... }:

let
  pinned-unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/669740ba937fb7f821a9528e9b6f5e1a6c5d4ab6.tar.gz") { };
  maybe-qtcreator = import (fetchTarball "https://github.com/Artturin/nixpkgs/archive/2e523a3b38aa498942103e3957adef16ad697247.tar.gz") { };
in
{
  imports = [ ../groups/graphical.nix ];

  home.packages = with pkgs; [
    # BASE
    openrgb
    (texlive.combine { inherit (texlive) scheme-medium moderncv multirow arydshln; })

    # GUI
    pinned-unstable.calibre
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
    glxinfo
    gnome3.cheese
    inkscape
    mediainfo
    pulseaudio
    qjackctl
    jackmix
    jamulus
    # (callPackage ../programs/jack_mixer.nix { })

    # DEV
    colordiff
    # .NET
    # (with dotnetCorePackages; combinePackages [ sdk_3_1 ])
    # omnisharp-roslyn dotnet-sdk
    # Java
    # adoptopenjdk-jre-openj9-bin-8 # JRE
    adoptopenjdk-bin # JDK
    # pkgsi686Linux.openjdk8
    # C/C++
    clang-tools
    cmake
    cppcheck
    hotspot
    linuxPackages.perf
    maybe-qtcreator.qtcreator
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
    nixops
    # Im
    discord
    teams
    skypeforlinux
    tdesktop

    # GAMES
    # steam
    # (steam.override {
    #   withPrimus = true;
    #   extraPkgs = pkgs: with pkgs; [
    #     nettools
    #     glxinfo
    #     mono
    #     gtk3
    #     gtk3-x11
    #     libgdiplus
    #     zlib
    #   ];
    #   nativeOnly = true;
    # }).run
    mupen64plus
    wxmupen64plus
    lutris-free
    mgba
    minecraft

    # VIRT/OP
    # nixops
    virtmanager
    nix-index
    virtualbox
    qemu
  ];

  home.file = {
    # Old version of chrome that still supports flash
    # pinned-oldstable = pkgs.callPackage ../nixpkgs-9518fac712ca001009bd12a3c94621f1ee805657/default.nix {
    #   config = {
    #     allowUnfree = true;
    #     chromium = {
    #       enablePepperFlash = true;
    #     };
    #   };
    # };
    # "Applications/old-chromium".source = pinned-oldstable.chromium;
    # ".config/chromium/Default/Pepper Data/Shockwave Flash/System/mms.cfg".source = ../files/mms.cfg;
  };

  programs = {
    obs-studio.enable = true;
  };

  nixpkgs.overlays = [
    (self: super: {
      obs-studio = pinned-unstable.obs-studio;
    })
  ];
}