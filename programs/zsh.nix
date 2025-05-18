{ pkgs
, lib
, config
, username
, ...
}:
let
  inherit (pkgs) stdenv;

  homeDirectory = if stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  initExtra = ''
    autopair-init
    # source ~/.zsh/p10k.zsh
    bindkey '^[[1;5C' emacs-forward-word
    bindkey '^[[1;5D' emacs-backward-word
  '';
in

{
  programs.oh-my-posh = {
    enable = true;
    # settings = {
    #   upgrade.notice = false;
    #   shell_integration = true;
    #   enable_cursor_positioning = true;
    # };
    useTheme = "powerlevel10k_rainbow";
  };

  programs.zsh = {
    enable = true;

    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    enableVteIntegration = !stdenv.isDarwin;

    history = {
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      path = "${config.xdg.stateHome}/zsh/history";
    };

    initExtraFirst = "export ZSH_COMPDUMP=\"${config.xdg.cacheHome}/zsh/zcompdump-\$HOST\"";

    initExtra =
      if stdenv.isDarwin then
        ''
          export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels''${NIX_PATH:+:$NIX_PATH}
        ''
        ++ initExtra
      else
        initExtra;

    plugins = import ./zsh/plugins.nix pkgs;

    sessionVariables = {
      EDITOR = "vim";
      TERM = "xterm-256color";
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
      SKIP_ELM_CODEGEN = "true";

      ELM_WATCH_OPEN_EDITOR = "code --goto \"\$file:\$line:\$column\"";

      ANDROID_HOME = "${config.xdg.dataHome}/android";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
      ELM_HOME = "${config.xdg.configHome}/elm";
      LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
      NODE_REPL_HISTORY = "${config.xdg.stateHome}/node/history";
      NUGET_PACKAGES = "${config.xdg.cacheHome}/NuGetPackages";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      SQLITE_HISTORY = "${config.xdg.cacheHome}/sqlite_history";
      WINEPREFIX = "${config.xdg.dataHome}/wine";
    } // (if stdenv.isDarwin then { VOLTA_HOME = "${homeDirectory}/.volta"; } else { });

    shellAliases = {
      open = "xdg-open";
      elm = "lamdera";
      c = "code .";
    };
  };
}
