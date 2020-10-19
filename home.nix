{ config, pkgs, ... }:
let
  unstable = import <unstable> {};
  vscodePackages = (import ./vscode-packages.nix).extensions;
in {
  home.packages = with pkgs; [
    # BASE
    neofetch

    # GUI
    yakuake
    spectacle gimp
    fira-code fira-code-symbols
    spotify vlc ffmpeg
    ark kcalc scribusUnstable okular libreoffice-still kate

    # NET
    openssl whois zoom-us nmap bmon dnsutils
    xdg-desktop-portal-kde plasma-browser-integration
    chromium

    # VIRT
    virt-manager vagrant

    # DEV
    gcc
    go golangci-lint
    python3
    gnumake
    git gitAndTools.qgit
    ripgrep
    cfssl
    unstable.dhall (hiPrio unstable.dhall-json) dhall-json
    elmPackages.elm elmPackages.elm-format elmPackages.elm-live nodejs
  ];

  fonts.fontconfig.enable = true;

  programs = {
    vscode = {
      enable = true;
      package = unstable.vscode;
      extensions = unstable.vscode-utils.extensionsFromVscodeMarketplace vscodePackages;
      userSettings = {
        editor = {
          fontFamily = "Fira Code";
          fontLigatures = true;
          formatOnSave = true;
          rulers = [85 120];
          codeLens = false;
        };
        workbench = {
          iconTheme = "vscode-icons";
          editor.enablePreview = false;
        };
        window.menuBarVisibility = "toggle";
        git = {
          enableSmartCommit = true;
          autofetch = true;
          confirmSync = false;
        };
        go.formatTool = "goimports";
        extensions.autoUpdate = false;
      };
    };

    firefox = {
      enable = true;
    };

    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins =  [
          "command-not-found"
          "git"
          "history"
          "sudo"
        ];
      };
      enableAutosuggestions = true;
      enableCompletion = true;
      autocd = true;

      sessionVariables = {
        EDITOR = "vim";
      };

      initExtra = ''
        autopair-init
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
