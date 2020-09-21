{ config, pkgs, ... }:
let
  unstable = import <unstable> {};
in {
  home.packages = with pkgs; [
    # GUI
    yakuake 
    spectacle gimp
    fira-code fira-code-symbols
    spotify

    # NET
    openssl whois zoom-us nmap
    xdg-desktop-portal-kde plasma-browser-integration

    # DEV
    git ripgrep ansible cfssl
  ];

  fonts.fontconfig.enable = true;

  programs = {
    vscode = {
      enable = true;
      package = unstable.vscode;
      extensions = with unstable.vscode-extensions; [
      ]
      ++ unstable.vscode-utils.extensionsFromVscodeMarketplace [
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
          version = "5.6.0";
          sha256 = "0qpnxz7q4dp6113cq2jlgcxxhpjs6xwkvkxqsch95pbzcp8jlqpp";
        }
        {
          name = "vscode-docker";
          publisher = "ms-azuretools";
          version = "1.5.0";
          sha256 = "06jn556k0frb4pfrncyr40skqhp548l2cw2q7lq20ga8i264asm7";
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
          version = "1.0.2740";
          sha256 = "11pfd4mxg8a2wrlnsbpk7apz69his7sgnzq6hp14wsw8p88wi61y";
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
          name = "vscode-icons";
          publisher = "vscode-icons-team";
          version = "10.2.0";
          sha256 = "13s5jrlj2czwh01bi4dds03hd9hpqk1gs9h0gja0g15d0j4kh39c";
        }
        {
          name = "vscode-ansible";
          publisher = "vscoss";
          version = "0.5.2";
          sha256 = "0r1aqfc969354j8b1k9xsg682fynbk4xjp196f3yknlwj66jnpwx";
        }
      ];
      userSettings = {
        editor = {
          fontFamily = "Fira Code";
          fontLigatures = true;
          formatOnSave = true;
          rulers = [85 120];
        };
        workbench.iconTheme = "vscode-icons";
        window.menuBarVisibility = "toggle";
        git.enableSmartCommit = true;
        git.autofetch = true;
      };
    };

    firefox = {
      enable = true;
    };

    zsh = {
      enable = true;
      oh-my-zsh.enable = true;
      sessionVariables = {
        EDITOR = "vim";
      };
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
