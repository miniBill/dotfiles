{
  description = "Home Manager and NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-24.11-small";
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # nixpkgs-unstable.url = "nixpkgs/nixos-unstable"; 

    # lamdera = {
    #   url = "github:miniBill/lamdera-flake";
    #   inputs.flake-utils.follows = "flake-utils";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # comma = {
    #   # just run any tool!
    #   url = "github:nix-community/comma";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.utils.follows = "flake-utils";
    #   inputs.flake-compat.follows = "flake-compat";
    # };

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
  };

  outputs = inputs:
    let
      allowedUnfree = [
        "code"
        "discord"
        "google-chrome"
        # "lamdera"
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
          # overlays = [ inputs.comma.overlay ];
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
        "minibill@gadiriel.local" = withConfig {
          system = "aarch64-darwin";
          module = ./machines/gadiriel/home-manager.nix;
        };
        "minibill@ithaca" = withConfig {
          system = "aarch64-linux";
          module = ./machines/ithaca/home-manager.nix;
        };
        "minibill@sohu" = withConfig {
          system = "aarch64-linux";
          module = ./machines/sohu/home-manager.nix;
        };
        "minibill@thamiel" = withConfig {
          system = "x86_64-linux";
          module = ./machines/thamiel/home-manager.nix;
        };
        "minibill@tharmas" = withConfig {
          system = "x86_64-linux";
          module = ./machines/tharmas/home-manager.nix;
        };
        "minibill@edge" = withConfig {
          system = "x86_64-linux";
          module = ./machines/edge/home-manager.nix;
        };
        "francesca@edge" = withConfig {
          system = "x86_64-linux";
          module = ./machines/edge/home-manager.nix;
        };
        "minibill@milky" = withConfig {
          system = "x86_64-linux";
          module = ./machines/milky/home-manager.nix;
        };
        "minibill@uriel" = withConfig {
          system = "x86_64-linux";
          module = ./machines/uriel/home-manager.nix;
        };
        "llibinim@uriel" = withConfig {
          system = "x86_64-linux";
          module = ./machines/uriel/home-manager.nix;
        };
      };
      nixosConfigurations = {
        uriel = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;
          modules = [ ./machines/uriel/configuration.nix ];
        };
        sohu = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = inputs;
          modules = [ ./machines/sohu/configuration.nix ];
        };
        tharmas = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;
          modules = [ ./machines/tharmas/configuration.nix ];
        };
        edge = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;
          modules = [ ./machines/edge/configuration.nix ];
        };
        thamiel = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;
          modules = [ ./machines/thamiel/configuration.nix ];
        };
        ithaca = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = inputs;
          modules = [ ./machines/ithaca/configuration.nix ];
        };
        milky = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;
          modules = [ ./machines/milky/configuration.nix ];
        };
      };
    };
}
