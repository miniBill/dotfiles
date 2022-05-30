{ config, pkgs, ... }:
let
  pinned-unstable-calibre = import ../repos/pinned-unstable-calibre.nix;
  pinned-unstable-youtube-dl = import ../repos/pinned-unstable-youtube-dl.nix;
  pinned-unstable-obs-studio = import ../repos/pinned-unstable-obs-studio.nix;
  pinned-unstable-discord = import ../repos/pinned-unstable-discord.nix;
  pinned-unstable-tdesktop = import ../repos/pinned-unstable-tdesktop.nix;
in {
  imports = [
    ../groups/graphical.nix
  ];

  home.packages = with pkgs; [
    # BASE
    (aspellWithDicts (d: [d.it])) nix-bundle

    # DEV
    colordiff gcc omnisharp-roslyn ghc
    (with dotnetCorePackages; combinePackages [ sdk_3_1 ])
    # Elm
    glslang adoptopenjdk-jre-openj9-bin-8
    qtcreator cmake clang-tools cppcheck linuxPackages.perf hotspot

    # MULTIMEDIA
    blender glxinfo mediainfo gnome3.cheese

    # NET
    skypeforlinux bind pinned-unstable-youtube-dl.youtubeDL
    (keepass.override { plugins = [ keepass-keepassrpc ]; })
    pinned-unstable-discord.discord teams zotero

    # BASE-GUI
    pinned-unstable-tdesktop.tdesktop gnome3.libgnomekbd
    winetricks wineWowPackages.stable

    # GAMES
    steam
    (steam.override {
      withPrimus = true;
      extraPkgs = pkgs: with pkgs; [
        # bumblebee
        nettools glxinfo mono gtk3 gtk3-x11 libgdiplus zlib
      ];
      nativeOnly = true;
    }).run
    mupen64plus wxmupen64plus


    # VIRT/OP
    nixops nix-index virtualbox qemu
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

  nixpkgs.overlays = [
    (self: super: {
      obs-studio = pinned-unstable-obs-studio.obs-studio;
    })
  ];
}
