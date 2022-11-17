{ pkgs, ... }:

let
  isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;
  isDarwin = pkgs.stdenv.isDarwin;
  onLinux = x: if isDarwin then [ ] else x;

  # Base - laptops and desktops
  packages-base = with pkgs; [
    neofetch
    nix-bundle
    nixpkgs-fmt
  ] ++ onLinux [
    usbutils
    (callPackage ../programs/wally-cli.nix { })
    (aspellWithDicts (d: [ d.it ]))
  ];

  # Dev
  packages-dev-base = with pkgs; [
    hyperfine
  ] ++ onLinux [
    gitAndTools.qgit

    (python3.withPackages (ps: [ ps.black ps.pillow ]))

    watchexec
  ];

  packages-dev-c = with pkgs; onLinux [
    gcc
    gdb
  ];

  package-dev-elm = with pkgs; [
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-json
    elmPackages.elm-live
    elmPackages.elm-test
    nodejs-18_x
    optipng
    jpegoptim
    yarn
    sass
  ];

  package-dev = packages-dev-base ++ packages-dev-c ++ package-dev-elm;

  # GUI
  packages-gui-fonts = with pkgs; [
    fira-code
    fira-code-symbols
    inter

    (callPackage ../fonts/linja-pona.nix { })
  ];

  packages-gui-kde = with pkgs; onLinux [
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

  packages-gui-misc = with pkgs; onLinux [
    gnome3.gnome-keyring # For vscode and saving passwords. Except it doesn't work. Eh.
    gparted
    libreoffice
    calibre
    virtmanager
  ] ++ lib.optionals (!isAarch64) [ rustdesk ];

  packages-gui-multimedia = with pkgs; [
    imagemagick
  ] ++ onLinux [
    audacity
    calf
    ffmpeg
    gimp
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
    with pkgs; lib.optionals (!isAarch64) [
      # etcher
      spotify
      zoom-us

      (callPackage ../programs/lamdera.nix { })
    ];

  packages-gui =
    packages-gui-fonts
    ++ packages-gui-kde
    ++ packages-gui-misc
    ++ packages-gui-multimedia
    ++ packages-gui-platform-specific;

  # Network
  packages-net-misc = with pkgs; onLinux [
    filezilla
    remmina
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

      ".config/pipewire/jack.conf.d/merge-monitor.conf".source = ../files/jack-merge-monitor.conf;

      ".config/yakuakerc".source = ../files/yakuakerc;
    };
  };

  programs = {
    chromium.enable = !isDarwin;

    firefox = {
      enable = !isDarwin;

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
      enable = !isDarwin;
      package =
        if isAarch64 then
          pkgs.vscode
        else
          pkgs.vscode-fhsWithPackages (ps: with ps; [ desktop-file-utils gnome3.gnome-keyring ]);
    };
  };

  services.gpg-agent = {
    enable = !isDarwin;
    enableSshSupport = !isDarwin;
  };
}
