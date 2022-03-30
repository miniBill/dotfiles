{ config, pkgs, ... }:

let
  pinned-unstable-calibre = import ../repos/pinned-unstable-calibre.nix;
  pinned-unstable-youtube-dl = import ../repos/pinned-unstable-youtube-dl.nix;
  pinned-unstable-obs-studio = import ../repos/pinned-unstable-obs-studio.nix;
  pinned-unstable-discord = import ../repos/pinned-unstable-discord.nix;
  pinned-unstable-tdesktop = import ../repos/pinned-unstable-tdesktop.nix;
  maybe-qtcreator = import ../repos/maybe-qtcreator.nix;
in
{
  imports = [ ../groups/graphical.nix ];

  home.packages = with pkgs; [
    # BASE
    openrgb
    (texlive.combine { inherit (texlive) scheme-medium moderncv multirow arydshln footmisc relsize; })

    # GUI
    pinned-unstable-calibre.calibre
    gnome3.libgnomekbd
    gparted
    libreoffice-fresh
    # Wine 
    winetricks
    wineWowPackages.stable
    # Multimedia
    ardour
    audacity
    blender
    carla
    clementine
    frescobaldi
    glxinfo
    gnome3.cheese
    inkscape
    jamulus
    mediainfo
    timidity
    vmpk
    # (callPackage ../programs/jack_mixer.nix { })

    # DEV
    colordiff
    valgrind
    (callPackage ../programs/lamdera.nix { })
    # .NET
    (with dotnetCorePackages; combinePackages [ dotnet-sdk_5 ])
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
    rustup
    # GLSL
    glslang
    # Misc
    ghc libwebp
    # zig sqlitebrowser binutils nasm

    # NET
    (keepass.override { plugins = [ keepass-keepassrpc ]; })
    bind
    google-chrome
    irssi
    pinned-unstable-youtube-dl.youtubeDL
    zotero
    nixops
    # Im
    pinned-unstable-discord.discord
    teams
    skypeforlinux
    pinned-unstable-tdesktop.tdesktop

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
      obs-studio = pinned-unstable-obs-studio.obs-studio;
    })
  ];
}
