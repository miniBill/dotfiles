{ config, pkgs, ... }:
{
  imports = [ ./machine-common.nix ];

  home = {
    file = {
      ".mozilla/firefox/ekr0xcc6.default/chrome/userChrome.css".source = ./files/userChrome.css;
    };

    packages = with pkgs; [
      # GUI
      jetbrains.datagrip
      libreoffice-still
      postgresql

      # DEV
      adoptopenjdk-icedtea-web
      ansible-lint
      cfssl
      go
      golangci-lint
    ];
  };

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

    zsh.initExtra = ''
      autopair-init
      source ~/.p10k.zsh
      ansible-short-diff () {
        export ANSIBLE_DISPLAY_OK_HOSTS=no ANSIBLE_DISPLAY_SKIPPED_HOSTS=no ANSIBLE_NOCOLOR=false 
      }
    '';
  };
}
