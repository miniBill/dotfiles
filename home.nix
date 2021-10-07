{ config, pkgs, ... }:
let
  pinned-unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/4ad4ae68c427ef8458be34051b4e545eb752811c.tar.gz") {};
  # pinned-oldstable = pkgs.callPackage ./nixpkgs-9518fac712ca001009bd12a3c94621f1ee805657/default.nix {
  #   config = {
  #     allowUnfree = true;
  #     chromium = {
  #       enablePepperFlash = true;
  #     };
  #   };
  # };

  pkgWithFlags = pkg: flags:
    pkgs.lib.overrideDerivation pkg (old:
    let
      oldflags = if (pkgs.lib.hasAttr "NIX_CFLAGS_COMPILE" old)
        then "${old.NIX_CFLAGS_COMPILE}"
        else "";
    in
    {
      NIX_CFLAGS_COMPILE = "${oldflags} ${flags}";
    });

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

  # polychromatic = pkgs.python3Packages.callPackage ./polychromatic.nix pkgs;
in {
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # BASE
    file unzip nix-bundle
    exa bc patchelf inotify-tools wally-cli neofetch pigz usbutils
    (aspellWithDicts (d: [d.it]))
    # openrgb polychromatic

    # DEV
    colordiff git gnumake gitAndTools.qgit
    # Elm
    elmPackages.elm-format elmPackages.elm elmPackages.elm-test elmPackages.elm-json elmPackages.elm-live
    optipng yarn nodejs (callPackage ./lamdera.nix {})
    # .NET
    (with dotnetCorePackages; combinePackages [ sdk_3_1 ]) omnisharp-roslyn # dotnet-sdk
    # zig sqlitebrowser
    # Java
    adoptopenjdk-jre-openj9-bin-8 # jre
    # pkgsi686Linux.openjdk8
    # C/C++
    qtcreator cmake clang-tools cppcheck gcc gdb linuxPackages.perf hotspot
    # Rust
    rustc cargo
    # GLSL
    glslang # (pkgWithFlags mesa "-Dwith_tools=[glsl]")
    # Misc
    ghc (python38.withPackages(ps: with ps; [ black ]))
    # binutils nasm
    # Dhall
    # dhall-lsp-server dhall

    # NET
    filezilla nmap ncat bind whois pinned-unstable.youtubeDL aria zotero
    bmon dnsutils jq mtr
    google-chrome
    (keepass.override { plugins = [ keepass-keepassrpc ]; })
    irssi
    # Im
    pinned-unstable.zoom-us discord teams skypeforlinux tdesktop

    # GUI
    ark yakuake kcharselect kcalc gnome3.libgnomekbd libsForQt5.spectacle
    gparted libreoffice-fresh xclip pinned-unstable.dbeaver etcher calibre
    # Wine
    winetricks wineWowPackages.stable
    # Multimedia
    gimp spotify inkscape okular ghostscript scribusUnstable blender glxinfo vlc imagemagick ffmpeg
    mediainfo qjackctl gnome3.cheese audacity clementine gwenview kolourpaint pinned-unstable.helvum carla
    pulseaudio
    # Fonts
    pinned-unstable.fira-code pinned-unstable.fira-code-symbols (callPackage ./linja-pona.nix {})

    # GAMES
    steam
    (steam.override {
      withPrimus = true;
      extraPkgs = pkgs: with pkgs; [
        nettools glxinfo mono gtk3 gtk3-x11 libgdiplus zlib
      ];
      nativeOnly = true;
    }).run
    mupen64plus wxmupen64plus
    lutris-free mgba

    # VIRT/OP
    # nixops
    virtmanager nix-index virtualbox qemu
  ];

  home.file = {
    ".npmrc".source = ./files/npmrc;
    ".p10k.zsh".source = ./files/p10k.zsh;
    ".alsoftrc".source = ./files/alsoftrc;
    ".mozilla/firefox/u3snpikq.default/chrome/userChrome.css".text = ''
        #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar > .toolbar-items {
          opacity: 0;
          pointer-events: none;
        }
        #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
            visibility: collapse !important;
        }'';

    # Old version of chrome that still supports flash
    # "Applications/old-chromium".source = pinned-oldstable.chromium;
    # ".config/chromium/Default/Pepper Data/Shockwave Flash/System/mms.cfg".source = ./files/mms.cfg;
  };

  programs = {
    chromium.enable = true;

    firefox.enable = true;

    tmux = {
      enable = true;
      newSession = true;
      extraConfig = "set-option -g mouse on";
      terminal = "xterm-256color";
    };

    fzf.enable = true;

    htop = {
      enable = true;
      settings.hide_userland_threads = true;
    };

    obs-studio = {
      enable = true;
    };

    vscode = {
      enable = true;
      package = pinned-unstable.vscode;
    };

    zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableVteIntegration = true;

      sessionVariables = {
        EDITOR = "vim";
        TERM = "xterm-256color";
      };

      history = {
        expireDuplicatesFirst = true;
        ignoreSpace = true;
      };

      shellAliases = {
        open = "xdg-open";
      };

      oh-my-zsh = {
        enable = true;
        plugins= [ "command-not-found" "git" "history" "ssh-agent" "sudo" "tmux" ];
      };

      initExtra = ''
        autopair-init
        source ~/.p10k.zsh
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
          name = "powerlevel10k";
          file = "powerlevel10k.zsh-theme";
          src = fetchFromGitHub {
            owner = "romkatv";
            repo = "powerlevel10k";
            rev = "8d1daa4e6340b1689bf951730489bc64c52220c7";
            sha256 = "0bm0dd4lb9kwv3xl6lk0wyb0fqq83gs8kl9111qs5ybavwcxlnnr";
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
  };

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.npm-global/bin"
  ];

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  nixpkgs.overlays = [
    (self: super: {
      obs-studio = pinned-unstable.obs-studio;
    })
  ];

  home.username = "minibill";
  home.homeDirectory = "/home/minibill";
  home.language.base = "it_IT.UTF-8";
}
