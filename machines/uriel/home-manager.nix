{
  pkgs,
  # , roc
  ...
}:

{
  imports = [ ../../groups/home-manager/graphical.nix ];

  home.packages = with pkgs; [
    # BASE
    # openrgb
    (texlive.combined.scheme-basic.withPackages (
      ps: with ps; [
        academicons
        arydshln
        fontawesome5
        footmisc
        moderncv
        multirow
        relsize
        scheme-medium
        textpos
      ]
    ))
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
    # clementine
    cheese
    jamulus
    mediainfo
    timidity
    vmpk
    # (callPackage ../../programs/jack_mixer.nix { })

    # DEV
    arduino
    colordiff
    valgrind
    # .NET
    # dotnet-runtime_8
    dotnetCorePackages.dotnet_8.sdk
    # Java
    # adoptopenjdk-jre-openj9-bin-8 # JRE
    # adoptopenjdk-bin # JDK
    # C/C++
    clang-tools
    cmake
    cppcheck
    linuxPackages.perf
    # GLSL
    glslang
    # Rust
    lld
    rustup
    pkg-config
    # Haskell
    # shake
    ghc
    # haskellPackages.hindent
    # haskellPackages.hlint
    # haskellPackages.stylish-haskell
    haskellPackages.haskell-language-server
    haskellPackages.stack
    # Misc
    ninja
    # cachix
    # zig sqlitebrowser binutils nasm
    dbeaver-bin
    # roc.packages.${system}.default
    # devenv
    devbox
    zed-editor

    # NET
    (keepass.override { plugins = [ keepass-keepassrpc ]; })
    bind
    google-chrome
    irssi
    zotero
    slack
    # Im
    signal-desktop
    x11vnc

    # GAMES
    heroic
    mupen64plus
    # lutris-free
    mgba
    prismlauncher

    # VIRT/OP
    # nix-index
    virtualbox
    qemu
  ];

  programs = {
    obs-studio.enable = true;

    firefox.profiles = {
      # bridgeverse = {
      #   isDefault = false;
      #   id = 1;

      #   settings = {
      #     "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      #   };

      #   userChrome = builtins.readFile ../../files/userChrome.css;
      # };
      empty = {
        id = 1;
      };
    };
  };
}
