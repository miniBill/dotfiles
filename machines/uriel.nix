{ config
, pkgs
, pinned-unstable-calibre
  # , pinned-unstable-discord
, pinned-unstable-piper
, ...
}:

{
  imports = [
    ../groups/graphical.nix
  ];

  home.packages = with pkgs; [
    # BASE
    openrgb
    (texlive.combine { inherit (texlive) academicons arydshln fontawesome5 footmisc moderncv multirow relsize scheme-medium textpos; })
    pinned-unstable-piper.piper

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
    # GLSL
    glslang
    # Rust
    lld
    cargo
    rust-analyzer
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
    zotero
    # Im
    # pinned-unstable-discord.discord
    discord
    skypeforlinux
    tdesktop
    signal-desktop
    x11vnc

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
    nixops
    nix-index
    virtualbox
    qemu
  ];

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
