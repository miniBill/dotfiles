{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    comma = {
      # just run any tool!
      url = "github:nix-community/comma";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    systems.url = "github:nix-systems/default";

    pinned-unstable-papermc.url = "github:NixOS/nixpkgs?rev=9dab6dd095a9ffec9981f2e213826b531452154d";

    # roc = {
    #   url = "github:roc-lang/roc";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    #   inputs.rust-overlay.follows = "rust-overlay";
    #   inputs.nixgl.follows = "nixgl";
    # };

    # rust-overlay = {
    #   url = "github:oxalica/rust-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    # };

    # nixgl = {
    #   url = "github:guibou/nixGL";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    # };

    # vscode 1.83.1
    # pinned-unstable-vscode.url = "github:NixOS/nixpkgs?rev=ad425c0caf8b588d7296393c629481f22fecd00b";

    # elm-format 0.8.7
    # pinned-unstable-elm-format.url = "github:NixOS/nixpkgs?rev=a7f2c2c93968445b88584847a48be245f8fd0a08";
  };

  nixConfig = {
    # extra-substituters = [
    #   "https://nix-community.cachix.org"
    #   "https://devenv.cachix.org"
    # ];
    # extra-trusted-public-keys = [
    #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #   "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    # ];
  };


  outputs = inputs:
    let
      withConfig =
        { system
        , username ? "minibill"
        , module
        }:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              overlays = [
                inputs.comma.overlay
              ];
              allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [
                "code"
                "discord"
                "google-chrome"
                "lamdera"
                "minecraft-launcher"
                "skypeforlinux"
                "slack"
                "spotify"
                "vscode"
                "zoom"
              ];
              permittedInsecurePackages = [
                "zotero-6.0.26"
              ];
            };
          };
          modules = [ module ];
          extraSpecialArgs = inputs // {
            inherit username;
            devenv = inputs.devenv.packages.${system}.devenv;

            # pinned-unstable-vscode = import inputs.pinned-unstable-vscode {
            #   inherit system;
            #   config = {
            #     allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [
            #       "code"
            #       "vscode"
            #     ];
            #   };
            # };
          };
        };
    in
    {
      homeConfigurations = {
        "minibill@uriel" = withConfig {
          system = "x86_64-linux";
          module = ./machines/uriel.nix;
        };
        "minibill@gadiriel" = withConfig {
          system = "aarch64-darwin";
          module = ./machines/gadiriel.nix;
        };
        "minibill@sohu" = withConfig {
          system = "aarch64-linux";
          module = ./machines/sohu.nix;
        };
        "minibill@tharmas" = withConfig {
          system = "x86_64-linux";
          module = ./machines/tharmas.nix;
        };
        "minibill@thamiel" = withConfig {
          system = "x86_64-linux";
          module = ./machines/thamiel.nix;
        };
      };
    };
}
