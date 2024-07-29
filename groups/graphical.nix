{ pkgs
, lib
  # , lamdera
  # , pinned-unstable-vscode
, ...
}:

let
  inherit (pkgs) stdenv;

  # Base - laptops and desktops
  packages-base = with pkgs; [
    neofetch
    nix-bundle
    nixpkgs-fmt
  ] ++ lib.optionals stdenv.isLinux [
    usbutils
    (callPackage ../programs/wally-cli.nix { })
    (aspellWithDicts (d: [ d.en d.it ]))
    hunspell
    hunspellDicts.en-us
    hunspellDicts.en-gb-ise
    hunspellDicts.it-it
    hunspellDicts.tok
  ];

  # Dev
  packages-dev-base = with pkgs; [
    hyperfine
    black
  ] ++ lib.optionals stdenv.isLinux [
    gitAndTools.qgit

    (python3.withPackages (ps: [ ps.pillow ps.pyserial ]))

    watchexec
  ];

  packages-dev-c = with pkgs; lib.optionals stdenv.isLinux [
    gcc
    gdb
  ];

  package-dev-elm = with pkgs; [
    elmPackages.elm-format
    elmPackages.elm-json
    # elmPackages.elm-test
    # lamdera.packages.${system}.lamdera-next
    nodejs_22
    optipng
    jpegoptim
    yarn
  ] ++ lib.optionals stdenv.isLinux [
    # elmPackages.elm
  ];

  package-dev = packages-dev-base ++ packages-dev-c ++ package-dev-elm;

  # GUI
  packages-gui-fonts = with pkgs; [
    fira-code
    fira-code-symbols
    inter
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    stix-two

    (callPackage ../fonts/linja-pona.nix { })
  ];

  packages-gui-kde = with pkgs; lib.optionals stdenv.isLinux [
    ark
    gwenview
    kcalc
    kcharselect
    kolourpaint
    okular
    plasma-browser-integration
    plasma5Packages.plasma-thunderbolt
    spectacle
    xdg-desktop-portal-kde
    yakuake
  ];

  packages-gui-misc = with pkgs; lib.optionals stdenv.isLinux [
    gparted
    libreoffice
    calibre
    virt-manager
    glxinfo
  ] ++ lib.optionals stdenv.isLinux [
    solaar
  ];

  packages-gui-multimedia = with pkgs; [
    imagemagick
    gimp
  ] ++ lib.optionals stdenv.isLinux [
    audacity
    calf
    ffmpeg
    inkscape
    jackmix
    pavucontrol
    pulseaudio
    qjackctl
    scribus
    vlc
    (callPackage ../programs/headset-control.nix { })
  ];

  packages-gui-platform-specific =
    with pkgs; lib.optionals stdenv.isx86_64 [
      # etcher
      spotify
      zoom-us
    ];

  packages-gui =
    packages-gui-fonts
    ++ packages-gui-kde
    ++ packages-gui-misc
    ++ packages-gui-multimedia
    ++ packages-gui-platform-specific;

  # Network
  packages-net-misc = with pkgs; lib.optionals stdenv.isLinux [
    filezilla
    remmina
    thunderbird
  ];

  packages-net = packages-net-misc;
in
{
  imports = [ ./base.nix ];

  fonts.fontconfig.enable = true;

  home = {
    packages =
      packages-base
      ++ package-dev
      ++ packages-gui
      ++ packages-net
    ;

    file = {
      # Always allow moving output devices in pavucontrol
      ".alsoftrc".source = ../files/alsoftrc;
      "bin/elm-format-hack".source = ../programs/elm-format-hack;
      "bin/elm-make-readable".source = ../programs/elm-make-readable;

      ".config/pipewire/jack.conf.d/merge-monitor.conf".source = ../files/jack-merge-monitor.conf;

      ".config/yakuakerc".source = ../files/yakuakerc;
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
          };

          userChrome = builtins.readFile ../files/userChrome.css;
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
