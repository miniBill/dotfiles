{ pkgs, ... }:

let
  pinned-unstable-calibre = import ../repos/pinned-unstable-calibre.nix;

  # Base - laptops and desktops
  packages-base = with pkgs; [
    neofetch
    nix-bundle
    nixpkgs-fmt

    usbutils

    (callPackage ../programs/wally-cli.nix { })

    (aspellWithDicts (d: [ d.it ]))
  ];

  # Dev
  packages-dev-base = with pkgs; [
    gitAndTools.qgit

    (python38.withPackages (ps: [ ps.black ]))

    watchexec
    sass
  ];

  packages-dev-c = with pkgs; [
    gcc
    gdb
  ];

  package-dev-elm = with pkgs; [
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-json
    elmPackages.elm-live
    elmPackages.elm-test
    nodejs
    optipng
    yarn
  ];

  package-dev = packages-dev-base ++ packages-dev-c ++ package-dev-elm;

  # GUI
  packages-gui-fonts = with pkgs; [
    fira-code
    fira-code-symbols

    (callPackage ../fonts/linja-pona.nix { })
  ];

  packages-gui-kde = with pkgs; [
    ark
    gwenview
    kcalc
    kcharselect
    kolourpaint
    okular
    plasma-browser-integration
    spectacle
    xdg-desktop-portal-kde
    yakuake
  ];

  packages-gui-misc = with pkgs; [
    gnome3.gnome-keyring # For vscode and saving passwords. Except it doesn't work. Eh.
    gparted
    libreoffice-still
    pinned-unstable-calibre.calibre
    virtmanager
  ];

  packages-gui-multimedia = with pkgs; [
    audacity
    calf
    ffmpeg
    gimp
    imagemagick
    jackmix
    pavucontrol
    pulseaudio
    qjackctl
    scribusUnstable
    vlc
    (callPackage ../programs/headset-control.nix { })
  ];

  packages-gui =
    packages-gui-fonts
    ++ packages-gui-kde
    ++ packages-gui-misc
    ++ packages-gui-multimedia;

  # Network
  packages-net-communication = with pkgs; [
  ];

  packages-net-misc = with pkgs; [
    filezilla
    remmina
  ];

  packages-net =
    packages-net-communication
    ++ packages-net-misc;
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

      ".config/pipewire/jack.conf".source = ../files/jack.conf;

      ".config/yakuakerc".source = ../files/yakuakerc;
    };
  };

  programs = {
    chromium.enable = true;

    firefox = {
      enable = true;

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
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
}
