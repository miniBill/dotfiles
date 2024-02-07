{ pkgs
  # , roc
, ...
}:

{
  imports = [ ../groups/graphical.nix ];

  home.packages = with pkgs; [
    # BASE
    openrgb
    (texlive.combined.scheme-basic.withPackages (ps: with ps; [ academicons arydshln fontawesome5 footmisc moderncv multirow relsize scheme-medium textpos ]))
    piper

    # GUI
    libgnomekbd
    x11vnc
    # Wine
    winetricks
    wineWowPackages.stable
    # Multimedia
    ardour
    carla
    clementine
    frescobaldi
    gnome3.cheese
    jamulus
    mediainfo
    timidity
    vmpk
    # (callPackage ../programs/jack_mixer.nix { })

    # DEV
    arduino
    colordiff
    valgrind
    # .NET
    dotnet-runtime
    # dotnet-sdk
    # Java
    # adoptopenjdk-jre-openj9-bin-8 # JRE
    adoptopenjdk-bin # JDK
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
    ninja
    libwebp
    cachix
    # zig sqlitebrowser binutils nasm
    dbeaver
    # roc.packages.${system}.default

    # NET
    (keepass.override { plugins = [ keepass-keepassrpc ]; })
    bind
    google-chrome
    irssi
    zotero
    slack
    # Im
    discord
    skypeforlinux
    tdesktop
    signal-desktop
    x11vnc

    # GAMES
    heroic
    mupen64plus
    lutris-free
    mgba
    prismlauncher

    # VIRT/OP
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
