{ config, pkgs, ... }:
let
  pinned-unstable-calibre = import ../repos/pinned-unstable-calibre.nix;
  pinned-unstable-discord = import ../repos/pinned-unstable-discord.nix;
  pinned-unstable-tdesktop = import ../repos/pinned-unstable-tdesktop.nix;
in
{
  imports = [
    ../groups/graphical.nix
  ];

  home.packages = with pkgs; [
    # BASE
    (aspellWithDicts (d: [ d.it ]))
    nix-bundle

    # DEV
    colordiff
    gcc
    omnisharp-roslyn
    ghc
    lld
    (with dotnetCorePackages; combinePackages [ sdk_3_1 ])
    # Elm
    glslang
    adoptopenjdk-jre-openj9-bin-8
    qtcreator
    cmake
    clang-tools
    cppcheck
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
    pinned-unstable-discord.discord
    zotero

    # BASE-GUI
    pinned-unstable-tdesktop.tdesktop
    libgnomekbd
    winetricks
    wineWowPackages.stable

    # GAMES
    mupen64plus

    # VIRT/OP
    nixops
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
