{
  pkgs,
  lib,
  # , lamdera
  # , pinned-unstable-vscode
  ...
}:

let
  inherit (pkgs) stdenv;

  # Base - laptops and desktops
  packages-base =
    with pkgs;
    [
      neofetch
      nix-bundle
      nixpkgs-fmt
      scrcpy
    ]
    ++ lib.optionals stdenv.isLinux [
      usbutils
      pcsc-tools
      cie-middleware-linux
      (callPackage ../../programs/wally-cli.nix { })
      (aspellWithDicts (d: [
        d.en
        d.it
      ]))
      hunspell
      hunspellDicts.en-us
      hunspellDicts.en-gb-ise
      hunspellDicts.it-it
      hunspellDicts.tok
    ];

  # Dev
  packages-dev-base =
    with pkgs;
    [
      hyperfine
      black
      typst
    ]
    ++ lib.optionals stdenv.isLinux [
      mold

      gitAndTools.qgit

      (python3.withPackages (ps: [
        ps.pillow
        ps.pyserial
      ]))

      watchexec
    ];

  packages-dev-c =
    with pkgs;
    lib.optionals stdenv.isLinux [
      gcc
      gdb
    ];

  package-dev-elm =
    with pkgs;
    [
      elmPackages.elm-json
      # elmPackages.elm-test
      # lamdera.packages.${system}.lamdera-next
      nodejs
      optipng
      jpegoptim
      corepack
    ]
    ++ lib.optionals stdenv.isLinux [
      elmPackages.elm-format
      # elmPackages.elm
    ];

  package-dev = packages-dev-base ++ packages-dev-c ++ package-dev-elm;

  # GUI
  packages-gui-kde =
    with pkgs.kdePackages;
    lib.optionals stdenv.isLinux [
      ark
      gwenview
      kcalc
      kcharselect
      kolourpaint
      okular
      plasma-browser-integration
      plasma-thunderbolt
      spectacle
      xdg-desktop-portal-kde
      yakuake
    ];

  packages-gui-misc =
    with pkgs;
    lib.optionals stdenv.isLinux [
      gparted
      libreoffice
      calibre
      virt-manager
      glxinfo
      graphviz-nox
      solaar
    ];

  packages-gui-multimedia =
    with pkgs;
    [
      imagemagick
      gimp
    ]
    ++ lib.optionals stdenv.isLinux [
      audacity
      calf
      easyeffects
      ffmpeg
      libwebp
      libavif
      inkscape
      jackmix
      pavucontrol
      pulseaudio
      qjackctl
      scribus
      vlc
      (callPackage ../../programs/headset-control.nix { })
    ];

  packages-gui-platform-specific =
    with pkgs;
    lib.optionals stdenv.isx86_64 [
      # etcher
      spotify
      zoom-us
    ];

  packages-gui =
    packages-gui-kde ++ packages-gui-misc ++ packages-gui-multimedia ++ packages-gui-platform-specific;

  # Network
  packages-net-misc =
    with pkgs;
    lib.optionals stdenv.isLinux [
      filezilla
      remmina
      thunderbird

      tdesktop
      discord
      signal-desktop
    ];

  packages-net = packages-net-misc;
in
{
  imports = [ ./base.nix ];

  home = {
    packages = packages-base ++ package-dev ++ packages-gui ++ packages-net;

    file = {
      # Always allow moving output devices in pavucontrol
      ".alsoftrc".source = ../../files/alsoftrc;

      "bin/elm-format-hack".source = ../../programs/elm-format-hack;
      "bin/elm-make-readable".source = ../../programs/elm-make-readable;

      ".npmrc".source = ../../files/npmrc;
      ".yarnrc".source = ../../files/yarnrc;

      ".config/pipewire/jack.conf.d/merge-monitor.conf".source = ../../files/jack-merge-monitor.conf;

      ".config/yakuakerc".source = ../../files/yakuakerc;
    };
  };

  programs = {
    chromium.enable = !stdenv.isDarwin;

    firefox = {
      enable = !stdenv.isDarwin;

      profiles = {
        main = {
          isDefault = true;

          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "dom.private-attribution.submission.enabled" = false;
          };

          userChrome = builtins.readFile ../../files/userChrome.css;
        };
      };
    };

    vscode = {
      enable = true;
      # package = pinned-unstable-vscode.vscode;
    };
  };

  services.gpg-agent = {
    enable = !stdenv.isDarwin;
    enableSshSupport = !stdenv.isDarwin;
  };
}
