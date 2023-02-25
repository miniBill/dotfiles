{ pkgs, config, username, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;

  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

  pnpm-home = "${homeDirectory}/.local/share/pnpm";
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

    initExtraFirst = "export ZSH_COMPDUMP=\"${config.xdg.cacheHome}/zsh/zcompdump-\$HOST\"";

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

    plugins = import ./zsh/plugins.nix pkgs;

    sessionVariables =
      {
        EDITOR = "vim";
        TERM = "xterm-256color";
        DOTNET_CLI_TELEMETRY_OPTOUT = "1";

        ANDROID_HOME = "${config.xdg.dataHome}/android";
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
        CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
        ELM_HOME = "${config.xdg.configHome}/elm";
        LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
        NUGET_PACKAGES = "${config.xdg.cacheHome}/NuGetPackages";
        PNPM_HOME = pnpm-home;
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        WINEPREFIX = "${config.xdg.dataHome}/wine";

        # RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      }
      //
      (if isDarwin then
        { VOLTA_HOME = "${homeDirectory}/.volta"; }
      else
        { });

    shellAliases = {
      open = "xdg-open";
    };
  };
}
