{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    lamdera = {
      url = "github:miniBill/lamdera-flake";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
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

    pinned-unstable-papermc.url = "github:NixOS/nixpkgs?rev=4cba8b53da471aea2ab2b0c1f30a81e7c451f4b6";
    pinned-unstable-devenv.url = "github:NixOS/nixpkgs?rev=4cba8b53da471aea2ab2b0c1f30a81e7c451f4b6";
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
          };
        };
    in
    {
      homeConfigurations = {
        "minibill@gadiriel" = withConfig {
          system = "aarch64-darwin";
          module = ./machines/gadiriel.nix;
        };
        "minibill@ithaca" = withConfig {
          system = "aarch64-linux";
          module = ./machines/ithaca.nix;
        };
        "minibill@sohu" = withConfig {
          system = "aarch64-linux";
          module = ./machines/sohu.nix;
        };
        "minibill@thamiel" = withConfig {
          system = "x86_64-linux";
          module = ./machines/thamiel.nix;
        };
        "minibill@tharmas" = withConfig {
          system = "x86_64-linux";
          module = ./machines/tharmas.nix;
        };
        "minibill@uriel" = withConfig {
          system = "x86_64-linux";
          module = ./machines/uriel.nix;
        };
      };
    };
}
