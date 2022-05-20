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
    exa bc patchelf file inotify-tools (aspellWithDicts (d: [d.it])) nix-bundle

    # DEV
    colordiff git gcc omnisharp-roslyn gnumake ghc
    (with dotnetCorePackages; combinePackages [ sdk_3_1 ])
    dhall-lsp-server dhall
    # Elm
    elmPackages.elm-format elmPackages.elm elmPackages.elm-test
    glslang
    # binutils zig colordiff sqlitebrowser jre nasm dotnet-sdk
    adoptopenjdk-jre-openj9-bin-8 # adoptopenjdk-bin
    qtcreator cmake clang-tools cppcheck gdb linuxPackages.perf hotspot
    rustc cargo optipng yarn

    # MULTIMEDIA
    gimp spotify inkscape okular ghostscript blender glxinfo vlc imagemagick ffmpeg mediainfo qjackctl gnome3.cheese audacity

    # NET
    filezilla skypeforlinux nmap ncat bind whois pinned-unstable-youtube-dl.youtubeDL
    (keepass.override { plugins = [ keepass-keepassrpc ]; })
    pinned-unstable-discord.discord firefox teams aria
    zotero

    # BASE-GUI
    ark yakuake kcharselect kolourpaint pinned-unstable-tdesktop.tdesktop kcalc gnome3.libgnomekbd spectacle wineWowPackages.stable okular gwenview
    fira-code fira-code-symbols gparted winetricks wineWowPackages.stable libreoffice-fresh

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
    nixops virtmanager nix-index virtualbox qemu
  ];

  programs = {
    obs-studio.enable = true;
  };

  nixpkgs.overlays = [
    (self: super: {
      obs-studio = pinned-unstable-obs-studio.obs-studio;
    })
  ];
}
