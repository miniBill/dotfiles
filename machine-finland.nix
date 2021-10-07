{ config, pkgs, ... }:
let
  pinned-unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/4ad4ae68c427ef8458be34051b4e545eb752811c.tar.gz") { };
  zoom-snapshot = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/5bb77e3ad96139efe668e81baea2ca064485f4d2.tar.gz") { };
in
{
  imports = [ ./machine-common.nix ];

  home.packages = with pkgs; [
    # GUI
    etcher
    jetbrains.datagrip
    libreoffice-still
    postgresql
    xclip

    # NET
    # zoom-us
    adoptopenjdk-icedtea-web
    bmon
    dnsutils
    filezilla
    jq
    nmap
    openssl
    plasma-browser-integration
    whois
    xdg-desktop-portal-kde
    zoom-snapshot.zoom-us

    # VIRT
    # virt-manager vagrant

    # DEV
    gcc
    gdb
    go
    golangci-lint
    python3 # python37Packages.black
    ripgrep
    cfssl
    ansible-lint
    dhall
    dhall-json
    dotnet-sdk # omnisharp-roslyn
  ];

  programs = {
    vscode = {
      enable = true;
      package = pinned-unstable.vscode;
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
