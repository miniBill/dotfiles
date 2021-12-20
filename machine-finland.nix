{ config, lib, pkgs, ... }:
let
  pinned-oldstable = import (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-20.09.tar.gz) { };
in
{
  imports = [ ./machine-base.nix ./machine-graphical.nix ];

  home = {
    packages = with pkgs; [
      # GUI
      jetbrains.datagrip
      dbeaver
      libreoffice-still
      postgresql

      # DEV
      adoptopenjdk-icedtea-web
      ansible-lint
      cfssl
      go
      golangci-lint

      pinned-oldstable.terraform_0_11
      google-cloud-sdk
    ];
  };

  systemd.user.tmpfiles.rules = [
    "d /home/minibill/.ssh/control 700 minibill users"
  ];

  programs = {
    vscode.userSettings = {
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

    zsh = {
      initExtra = ''
        ansible-short-diff () {
          export ANSIBLE_DISPLAY_OK_HOSTS=no ANSIBLE_DISPLAY_SKIPPED_HOSTS=no ANSIBLE_NOCOLOR=false 
        }
      '';
      sessionVariables = {
        # used by rstor_ansible.sh
        DOCKER_EXTRA = ''
          -v /nix:/nix:ro \
          -v /home/minibill/.ssh/control:/home/minibill/.ssh/control:rw'';
      };
    };

    ssh = {
      enable = true;
      controlMaster = "auto";
      controlPath = "~/.ssh/control/%r@%h:%p";
      controlPersist = "10m";
      matchBlocks = {
        "10.0.0.*" = lib.hm.dag.entryBefore
          [ "*.rstor.net 209.163.* 10.* ns*.rstorcloud.io" ]
          {
            user = "minibill";
          };
        "rramp-gcp-* 10.128.0.*" = lib.hm.dag.entryBefore
          [ "*.rstor.net 209.163.* 10.* ns*.rstorcloud.io" ]
          {
            user = "minibill";
            # pubkeyAuthentication = "yes";
            proxyJump = "storage-ops-usc.packetfabric.net"; # 10.4.2.21
          };
        "*.rstor.net 209.163.* 216.180.* 10.* ns*.rstorcloud.io" = {
          user = "ltaglialegne";
          proxyJump = "storage-ops-usc.packetfabric.net";
        };
        "ci.pre-rstor.com" = {
          hostname = "172.30.23.11";
        };
        "storage-ops storage-ops-usc.packetfabric.net" = {
          hostname = "storage-ops-usc.packetfabric.net";
          dynamicForwards = [{ port = 1080; }];
          extraOptions = { ControlPersist = "12h"; };
        };
        "lax01-jumphost01 jump01.lax01 jump01.lax01.rstor.net 10.3.204.168" = {
          hostname = "10.3.204.168";
        };
        "dca02-jumphost01 jump01.dca02 jump01.dca02.rstor.net 10.4.204.215" = {
          hostname = "10.4.204.215";
        };
      };
      extraConfig = ''
        CanonicalizeHostname yes
        CanonicalDomains rstor.net rstorcloud.io
        CanonicalizeMaxDots 1
        CanonicalizeFallbackLocal yes
        CanonicalizePermittedCNAMEs *.rstor.net:*.rstor.net *.rstorcloud.io:*.rstorcloud.io'';
    };
  };
}
