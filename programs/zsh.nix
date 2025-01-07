{ pkgs, config, username, ... }:
let
  inherit (pkgs) stdenv;

  homeDirectory =
    if stdenv.isDarwin then
      "/Users/${username}"
    else
      "/home/${username}";
in

{
  # programs.starship = {
  #   enable = true;
  #   settings = {
  #     add_newline = false;
  #     format = "$directory$vcsh$fossil_branch$fossil_metrics$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$character";
  #     git_branch.format = "[$branch(:$remote_branch)](green) ";
  #     right_format = "$all";
  #   };
  # };

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

    plugins = import ./zsh/plugins.nix pkgs;

    sessionVariables =
      {
        EDITOR = "vim";
        TERM = "xterm-256color";
        DOTNET_CLI_TELEMETRY_OPTOUT = "1";
        SKIP_ELM_CODEGEN = "true";

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

        # RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      }
      //
      (if stdenv.isDarwin then
        { VOLTA_HOME = "${homeDirectory}/.volta"; }
      else
        { });

    shellAliases = {
      open = "xdg-open";
      elm = "lamdera";
      c = "code .";
    };
  };
}
