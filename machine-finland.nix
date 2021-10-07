{ config, pkgs, ... }:
let
  unstable = import <unstable> { };
  zoom-snapshot = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/5bb77e3ad96139efe668e81baea2ca064485f4d2.tar.gz") { };

  wally-cli = pkgs.stdenv.mkDerivation {
    name = "wally-cli-2.0.0";
    src = pkgs.fetchurl {
      name = "wally-cli";
      url = "https://github.com/zsa/wally-cli/releases/download/2.0.0-linux/wally-cli";
      sha256 = "0048ndgk0r2ln0f4pcy05xfwp022q8p7sdwyrfjk57d8q4f773x3";
    };
    dontStrip = true;
    unpackPhase = ''
      cp $src ./wally-cli
    '';
    installPhase = ''
      mkdir -p $out/bin
      chmod +wx wally-cli
      cp wally-cli $out/bin
      ${pkgs.patchelf}/bin/patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${pkgs.lib.makeLibraryPath [ pkgs.libusb1 ]}" \
        $out/bin/wally-cli
    '';
  };
in
{
  home.packages = with pkgs; [
    # BASE
    neofetch
    file
    nix-bundle
    pigz
    wally-cli
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
    chromium
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

  home.sessionPath = [
    "$HOME/.npm/bin"
  ];

  fonts.fontconfig.enable = true;

  programs = {
    fzf.enable = true;

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

    firefox = {
      enable = true;
    };

    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "command-not-found"
          "git"
          "history"
          "sudo"
          "ssh-agent"
        ];
      };
      enableAutosuggestions = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autocd = true;

      sessionVariables = {
        EDITOR = "vim";
        TERM = "xterm-256color";
      };

      initExtra = ''
        autopair-init
        ansible-short-diff () {
          export ANSIBLE_DISPLAY_OK_HOSTS=no ANSIBLE_DISPLAY_SKIPPED_HOSTS=no ANSIBLE_NOCOLOR=false 
        }
      '';

      plugins = with pkgs; [
        {
          name = "zsh-syntax-highlighting";
          src = fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.6.0";
            sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
          };
          file = "zsh-syntax-highlighting.zsh";
        }
        {
          name = "zsh-autopair";
          src = fetchFromGitHub {
            owner = "hlissner";
            repo = "zsh-autopair";
            rev = "34a8bca0c18fcf3ab1561caef9790abffc1d3d49";
            sha256 = "1h0vm2dgrmb8i2pvsgis3lshc5b0ad846836m62y8h3rdb3zmpy1";
          };
          file = "autopair.zsh";
        }
        {
          name = "powerlevel9k";
          file = "powerlevel9k.zsh-theme";
          src = fetchFromGitHub {
            owner = "bhilburn";
            repo = "powerlevel9k";
            rev = "571a859413866897cf962396f02f65a288f677ac";
            sha256 = "0xwa1v3c4p3cbr9bm7cnsjqvddvmicy9p16jp0jnjdivr6y9s8ax";
          };
        }
        {
          name = "nix-shell";
          src = fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "03a1487655c96a17c00e8c81efdd8555829715f8";
            sha256 = "1avnmkjh0zh6wmm87njprna1zy4fb7cpzcp8q7y03nw3aq22q4ms";
          };
        }
      ];
    };

    home-manager.enable = true;
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
