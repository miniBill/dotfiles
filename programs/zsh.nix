{ pkgs, config, username, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;

  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

  pnpm-home = homeDirectory + "/.local/share/pnpm";
in

{
  programs.zsh = {
    enable = true;

    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = !isDarwin;

    history = {
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      path = "${config.xdg.stateHome}/zsh/history";
    };

    initExtra =
      if isDarwin then
        ''
          export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels''${NIX_PATH:+:$NIX_PATH}
            
          autopair-init
          source ~/.zsh/p10k.zsh
        ''
      else
        ''
          autopair-init
          source ~/.zsh/p10k.zsh
        '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "command-not-found" "git" "history" "ssh-agent" "sudo" "tmux" ];
    };

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
        name = "zsh-aws-vault";
        src = fetchFromGitHub
          {
            owner = "blimmer";
            repo = "zsh-aws-vault";
            rev = "818fc96a73512dd86bfcad850c430e974fd53d78";
            sha256 = "sha256-WuzBwfIOmENQpo94r9+h2E0OEzs1bGNbLy/D2izK+Qw=";
          };
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
          rev = "v0.5.0";
          sha256 = "IT3wpfw8zhiNQsrw59lbSWYh0NQ1CUdUtFzRzHlURH0=";
        };
      }
    ];

    sessionVariables =
      {
        EDITOR = "vim";
        TERM = "xterm-256color";
        DOTNET_CLI_TELEMETRY_OPTOUT = "1";

        ANDROID_HOME = "${config.xdg.dataHome}/android";
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
        CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        PNPM_HOME = pnpm-home;
        WINEPREFIX = "${config.xdg.dataHome}/wine";

        # RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      }
      //
      (if isDarwin then
        {
          VOLTA_HOME = homeDirectory + "/.volta";
        }
      else
        { });

    shellAliases = {
      open = "xdg-open";
    };
  };
}
