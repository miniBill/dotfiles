{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    lamdera = {
      url = "github:miniBill/lamdera-flake";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
  };

  outputs = inputs:
    let
      allowedUnfree = [
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

      pkgs = system: import inputs.nixpkgs {
        inherit system;
        config = {
          overlays = [ inputs.comma.overlay ];
          allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) allowedUnfree;
          permittedInsecurePackages = [
            "zotero-6.0.26"
          ];
        };
      };

      withConfig =
        { system
        , username ? "minibill"
        , module
        }:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs system;
          modules = [ module ];
          extraSpecialArgs = inputs // {
            inherit username;
            devenv = inputs.devenv.packages.${system}.devenv;
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
