{ pkgs, lib, config, username, ... }:
let
  inherit (pkgs) stdenv;

  homeDirectory =
    if stdenv.isDarwin then
      "/Users/${username}"
    else
      "/home/${username}";
in

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$directory"
        "$vcsh"
        "$fossil_branch"
        "$fossil_metrics"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$hg_branch"
        "$pijul_channel"
        "$direnv"
        "$shlvl"
        "$character"
      ];
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "dimmed yellow";
      };
      directory = {
        truncate_to_repo = false;
        fish_style_pwd_dir_length = 4;
        truncation_length = 4;
        style = "blue";
      };
      git_branch.format = "[$branch(:$remote_branch)](green) ";
      git_status = {
        format = "([$all_status$ahead_behind]($style))";
        style = "dimmed yellow";
        conflicted = "[=$count](bold red)";
        ahead = "⇡$count ";
        behind = "⇣$count ";
        diverged = "⇡$ahead_count ⇣$behind_count";
        untracked = "?$count ";
        stashed = "\\$$count ";
        modified = "!$count ";
        staged = "[*$count ](green)";
        renamed = "»$count ";
        deleted = "[✘$count ](bold red)";
      };
      hostname = {
        format = "[$hostname]($style)";
        style = "dimmed green";
      };
      localip = {
        disabled = false;
        style = "dimmed cyan";
        format = "[@](dimmed white)[$localipv4]($style) ";
      };
      nix_shell = {
        heuristic = true;
        format = "via [$symbol$state]($style) ";
      };
      # shlvl = {
      #   disabled = false;
      #   format = "[$symbol]($style)";
      #   repeat = true;
      #   symbol = "❯";
      #   repeat_offset = 1;
      #   threshold = 0;
      # };
      time = {
        disabled = false;
        format = "[$time]($style)";
        style = "dimmed white";
      };
      username = {
        format = "[$user]($style)[@](dimmed white)";
        style_root = "red";
        style_user = "dimmed yellow";
      };
      right_format = lib.concatStrings [
        "$container"
        "$username"
        "$hostname"
        "$localip"
        "$nix_shell"
        "$cmd_duration"
        "$jobs"
        "$battery"
        "$time"
      ];
    };
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

          autopair-init
          # source ~/.zsh/p10k.zsh
          bindkey '^[[1;5C' emacs-forward-word
          bindkey '^[[1;5D' emacs-backward-word
        ''
      else
        ''
          autopair-init
          # source ~/.zsh/p10k.zsh
          bindkey '^[[1;5C' emacs-forward-word
          bindkey '^[[1;5D' emacs-backward-word
        '';

    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [ "command-not-found" "git" "history" "ssh-agent" "sudo" "tmux" ];
    # };

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
