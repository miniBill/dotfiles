{ config, pkgs, ... }:
let
  unstable = import <unstable> {};
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
      extensions = unstable.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "bracket-pair-colorizer-2";
          publisher = "CoenraadS";
          version = "0.2.0";
          sha256 = "0nppgfbmw0d089rka9cqs3sbd5260dhhiipmjfga3nar9vp87slh";
        }
        {
          name = "Nix";
          publisher = "bbenoist";
          version = "1.0.1";
          sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
        }
        {
          name = "gitlens";
          publisher = "eamodio";
          version = "10.2.2";
          sha256 = "00fp6pz9jqcr6j6zwr2wpvqazh1ssa48jnk1282gnj5k560vh8mb";
        }
        {
          name = "prettier-vscode";
          publisher = "esbenp";
          version = "5.7.1";
          sha256 = "0f2q17d028j2c816rns9hi2w38ln3mssdcgzm6kc948ih252jflr";
        }
        {
          name = "go";
          publisher = "golang";
          version = "0.17.1";
          sha256 = "1dr0lfnnzs6divhkgqnppda1s613isbn0k7ggzl96b3qxwrrvsni";
        }
        {
          name = "vscode-docker";
          publisher = "ms-azuretools";
          version = "1.6.0";
          sha256 = "1snjj09qn0c6ipd3i3xyzah4gnh17j5h9vn01db294xpbl2q80n0";
        }
        {
          name = "remote-ssh";
          publisher = "ms-vscode-remote";
          version = "0.55.0";
          sha256 = "1rzdz6539zbqsh3ikwmysz0587s1p5w72bqry17147s7hk513gn0";
        }
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.55.0";
          sha256 = "0bqjp0xzliyzp8kq3ss4b4by402p2l4fbdms8955yk1vp88d0lfa";
        }
        {
          name = "vsliveshare";
          publisher = "ms-vsliveshare";
          version = "1.0.2902";
          sha256 = "0fx2vi0wxamcwqcgcx7wpg8hi7f1c2pibrmd2qy2whilpsv3gzmb";
        }
        {
          name = "nftalbs";
          publisher = "omBratteng";
          version = "0.0.2";
          sha256 = "152r00m25ad1jla6s45lc7qcwkisy3iybb3incn0nhxx37d0c09a";
        }
        {
          name = "vscode-vault";
          publisher = "owenfarrell";
          version = "2.2.2";
          sha256 = "18nkz5drnqzzmgyxgiyrfpbiajwa095c3xzcjbvxxhsp3hm1hkw8";
        }
        {
          name = "docker-compose";
          publisher = "p1c2u";
          version = "0.3.5";
          sha256 = "0ghyy5zll82yp0ddxspwcaa47dycc2g8lgy47wj7jvgiqdh1g5aw";
        }
        {
          name = "dhall-lang";
          publisher = "panaeon";
          version = "0.0.4";
          sha256 = "0qcxasjlhqvl5zyf7w9fjx696gnianx7c959g2wssnwyxh7d14ka";
        }
        {
          name = "vscode-dhall-lsp-server";
          publisher = "panaeon";
          version = "0.0.4";
          sha256 = "0ws2ysra5iifhqd2zf7zy2kcymacr5ylcmi1i1zqljkpqqmvnv5q";
        }
        {
          name = "jenkinsfile-support";
          publisher = "secanis";
          version = "0.1.0";
          sha256 = "0qijj78ndy6vw2qalcjaj80n8ba2cv2fkrc2a0dqn01bsp385nml";
        }
        {
          name = "vscode-icons";
          publisher = "vscode-icons-team";
          version = "11.0.0";
          sha256 = "18gf6ikkvqrihblwpmb4zpxg792la5yg8pwfaqm07dzwzfzxxvmv";
        }
        {
          name = "vscode-ansible";
          publisher = "vscoss";
          version = "0.5.2";
          sha256 = "0r1aqfc969354j8b1k9xsg682fynbk4xjp196f3yknlwj66jnpwx";
        }
        {
          name = "python";
          publisher = "ms-python";
          version = "2020.9.112786";
          sha256 = "0n7sgx8k9zrdrl4iqvhyqizi7ak0z6vva3paryfd7rivp0g3caw4";
        }
        {
          name = "jinja";
          publisher = "wholroyd";
          version = "0.0.8";
          sha256 = "1ln9gly5bb7nvbziilnay4q448h9npdh7sd9xy277122h0qawkci";
        }
      ];
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
