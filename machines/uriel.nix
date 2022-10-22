{ config, pkgs, ... }:

let
  pinned-unstable-calibre = import ../repos/pinned-unstable-calibre.nix;
  pinned-unstable-youtube-dl = import ../repos/pinned-unstable-youtube-dl.nix;
  pinned-unstable-discord = import ../repos/pinned-unstable-discord.nix;
  # pinned-unstable-tdesktop = import ../repos/pinned-unstable-tdesktop.nix;
  maybe-qtcreator = import ../repos/maybe-qtcreator.nix;
in
{
  imports = [
    ../groups/graphical.nix
  ];

  home.packages = with pkgs; [
    # BASE
    openrgb
    (texlive.combine { inherit (texlive) academicons arydshln fontawesome5 footmisc moderncv multirow relsize scheme-medium textpos; })

    # GUI
    libgnomekbd
    # Wine
    winetricks
    wineWowPackages.stable
    # Multimedia
    ardour
    blender
    carla
    clementine
    frescobaldi
    glxinfo
    gnome3.cheese
    jamulus
    mediainfo
    timidity
    vmpk
    # (callPackage ../programs/jack_mixer.nix { })

    # DEV
    colordiff
    valgrind
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
    # GLSL
    glslang
    # Rust
    lld
    cargo
    rustc
    rustfmt
    pkg-config
    # Misc
    shake
    ghc
    haskellPackages.hindent
    haskellPackages.hlint
    haskellPackages.stylish-haskell
    libwebp
    cachix
    # zig sqlitebrowser binutils nasm
    dbeaver

    # NET
    (keepass.override { plugins = [ keepass-keepassrpc ]; })
    bind
    google-chrome
    irssi
    pinned-unstable-youtube-dl.youtube-dl
    zotero
    nixops
    # Im
    pinned-unstable-discord.discord
    # discord
    skypeforlinux
    # pinned-unstable-tdesktop.tdesktop
    tdesktop
    signal-desktop

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
    heroic
    mupen64plus
    lutris-free
    mgba
    minecraft

    # VIRT/OP
    # nixops
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

    firefox.profiles = {
      bridgeverse = {
        isDefault = false;
        id = 1;

        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };

        userChrome = builtins.readFile ../files/userChrome.css;
      };
    };
  };
}
