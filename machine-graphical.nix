{ pkgs, ... }:
let
  pinned-unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/4ad4ae68c427ef8458be34051b4e545eb752811c.tar.gz") { };

  # Base - laptops and desktops
  packages-base = with pkgs; [
    neofetch
    nix-bundle
    nixpkgs-fmt

    usbutils

    (callPackage ./programs/wally-cli.nix { })

    (aspellWithDicts (d: [ d.it ]))
  ];

  # Dev
  packages-dev-base = with pkgs; [
    gitAndTools.qgit

    (python38.withPackages (ps: [ ps.black ]))
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

    (callPackage ./programs/lamdera.nix { })
  ];

  package-dev = packages-dev-base ++ packages-dev-c ++ package-dev-elm;

  # GUI
  packages-gui-fonts = with pkgs; [
    fira-code
    fira-code-symbols

    (callPackage ./linja-pona.nix { })
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
    etcher
    gnome3.gnome-keyring # For vscode and saving passwords. Except it doesn't work. Eh.
  ];

  packages-gui-multimedia = with pkgs; [
    ffmpeg
    imagemagick
    gimp
    scribusUnstable
    spotify
    vlc
  ];

  packages-gui =
    packages-gui-fonts
    ++ packages-gui-kde
    ++ packages-gui-misc
    ++ packages-gui-multimedia;

  # Network
  packages-net-communication = with pkgs; [
    pinned-unstable.zoom-us
  ];

  packages-net-misc = with pkgs; [
    filezilla
  ];

  packages-net =
    packages-net-communication
    ++ packages-net-misc;
in
{
  fonts.fontconfig.enable = true;

  home = {
    packages =
      packages-base
      ++ package-dev
      ++ packages-gui
      ++ packages-net
    ;
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

          userChrome = builtins.readFile ./files/userChrome.css;
        };
      };
    };

    vscode = {
      enable = true;
      package = pinned-unstable.vscode;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
}
