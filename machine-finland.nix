{ config, pkgs, ... }:
let
  unstable = import <unstable> { };
  zoom-snapshot = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/5bb77e3ad96139efe668e81baea2ca064485f4d2.tar.gz") { };
in
{
  imports = [ ./machine-common.nix ];

  home.packages = with pkgs; [
    # BASE
    neofetch
    file
    nix-bundle
    pigz
    (callPackage ./programs/wally-cli.nix { })
    usbutils
    smem
    imagemagick
    nixpkgs-fmt

    # GUI
    yakuake
    xclip
    spectacle
    gimp
    fira-code
    fira-code-symbols
    spotify
    vlc
    ffmpeg
    ark
    kcalc
    scribusUnstable
    okular
    kate
    libreoffice-still
    unstable.dbeaver
    postgresql
    jetbrains.datagrip
    etcher

    # NET
    openssl
    whois
    zoom-snapshot.zoom-us
    # zoom-us
    bmon
    dnsutils
    jq
    nmap
    xdg-desktop-portal-kde
    plasma-browser-integration
    adoptopenjdk-icedtea-web
    filezilla

    # VIRT
    # virt-manager vagrant

    # DEV
    gcc
    gdb
    go
    golangci-lint
    python3 # python37Packages.black
    gnumake
    git
    gitAndTools.qgit
    ripgrep
    cfssl
    ansible-lint
    dhall
    dhall-json
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-live
    elmPackages.elm-json
    nodejs
    dotnet-sdk # omnisharp-roslyn
  ];

  programs = {
    vscode = {
      enable = true;
      package = unstable.vscode;
      userSettings = {
        # omnisharp.path = "/run/current-system/sw/bin/omnisharp";
        editor = {
          fontFamily = "Fira Code";
          fontLigatures = true;
          formatOnSave = true;
          rulers = [ 85 120 ];
          codeLens = false;
          renderWhitespace = "boundary";
        };
        workbench = {
          iconTheme = "vscode-icons";
          editor.enablePreview = false;
          editor.wrapTabs = true;
        };
        window.menuBarVisibility = "toggle";
        git = {
          enableSmartCommit = true;
          autofetch = "all";
          confirmSync = false;
        };
        go.formatTool = "goimports";
        extensions.autoUpdate = false;
        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[jsonc]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[yaml]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };
        "[html]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        elmLs = {
          elmPath = "elm";
        };
        python.formatting = {
          provider = "black";
          blackPath = "/home/minibill/.nix-profile/bin/black";
        };
        yaml.customTags = [ "!encrypted/pkcs1-oaep scalar" "!vault scalar" ];
        redhat.telemetry.enabled = false;
        update.mode = "none";
        python.showStartPage = false;
      };
    };

    zsh = {
      initExtra = ''
        autopair-init
        source ~/.p10k.zsh
        ansible-short-diff () {
          export ANSIBLE_DISPLAY_OK_HOSTS=no ANSIBLE_DISPLAY_SKIPPED_HOSTS=no ANSIBLE_NOCOLOR=false 
        }
      '';
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";
}
