{ pkgs, ... }:

{
  imports = [ ../groups/graphical.nix ];

  home.packages = with pkgs; [
    # DEV
    colordiff
    gcc
    omnisharp-roslyn
    ghc
    lld
    # (with dotnetCorePackages; combinePackages [ sdk_3_1 ])
    # Elm
    glslang
    linuxPackages.perf
    hotspot

    # MULTIMEDIA
    blender
    glxinfo
    mediainfo
    gnome3.cheese

    # NET
    skypeforlinux
    bind
    (keepass.override { plugins = [ keepass-keepassrpc ]; })
    zotero

    # BASE-GUI
    libgnomekbd
    winetricks
    wineWowPackages.stable

    # GAMES
    mupen64plus

    # VIRT/OP
    nix-index
    virtualbox
    qemu
  ];

  programs = {
    obs-studio.enable = true;

    ssh = {
      matchBlocks = {
        "cjmilky" = {
          hostname = "fc7b:a519:e66f:2ce9:feb3:731e:cb6d:3144";
        };
      };
    };
  };
}
