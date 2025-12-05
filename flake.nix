{
  description = "Home Manager and NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-25.11-small";

    # nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    systems.url = "github:nix-systems/default";

    secretdemoclub = {
      url = "github:miniBill/secretdemoclub?dir=server";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "systems";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # lamdera = {
    #   url = "github:miniBill/lamdera-flake";
    #   inputs.flake-utils.follows = "flake-utils";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

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

    # flake-compat = {
    #   url = "github:edolstra/flake-compat";
    #   flake = false;
    # };
  };

  outputs =
    inputs:
    let
      allowedUnfree = [
        "code"
        "discord"
        "google-chrome"
        # "lamdera"
        "minecraft-launcher"
        "slack"
        "spotify"
        "vscode"
        "zoom"
      ];

      pkgs =
        system:
        import inputs.nixpkgs {
          system = system;
          config = {
            # overlays = [ inputs.comma.overlay ];
            allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) allowedUnfree;

            permittedInsecurePackages = [
              "zotero-6.0.26"
            ];
          };
        };

      withConfig =
        {
          arch ? "x86_64",
          username ? "minibill",
          os ? "linux",
          module,
        }:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs (arch + "-" + os);
          modules = [ module ];
          extraSpecialArgs = inputs // {
            username = username;
          };
        };
    in
    {
      homeConfigurations = {
        "minibill@gadiriel" = withConfig {
          arch = "aarch64";
          os = "darwin";
          module = ./machines/gadiriel/home-manager.nix;
        };
        "minibill@ithaca" = withConfig {
          arch = "aarch64";
          module = ./machines/ithaca/home-manager.nix;
        };
        "minibill@sohu" = withConfig {
          arch = "aarch64";
          module = ./machines/sohu/home-manager.nix;
        };
        "minibill@thamiel" = withConfig {
          module = ./machines/thamiel/home-manager.nix;
        };
        "minibill@tharmas" = withConfig {
          module = ./machines/tharmas/home-manager.nix;
        };
        "minibill@edge" = withConfig {
          module = ./machines/edge/home-manager.nix;
        };
        "francesca@edge" = withConfig {
          username = "francesca";
          module = ./machines/edge/home-manager.nix;
        };
        "minibill@milky" = withConfig {
          module = ./machines/milky/home-manager.nix;
        };
        "minibill@uriel" = withConfig {
          module = ./machines/uriel/home-manager.nix;
        };
        "llibinim@uriel" = withConfig {
          username = "llibinim";
          module = ./machines/uriel/home-manager.nix;
        };
        "minibill@nathanda" = withConfig {
          module = ./machines/nathanda/home-manager.nix;
        };
      };
      nixosConfigurations =
        let
          nixosSystem =
            {
              arch ? "x86_64",
              module,
            }:
            inputs.nixpkgs.lib.nixosSystem {
              system = arch + "-linux";
              specialArgs = inputs;
              modules = [ module ];
            };
        in
        {
          uriel = nixosSystem {
            module = ./machines/uriel/configuration.nix;
          };
          sohu = nixosSystem {
            arch = "aarch64";
            module = ./machines/sohu/configuration.nix;
          };
          tharmas = nixosSystem {
            module = ./machines/tharmas/configuration.nix;
          };
          edge = nixosSystem {
            module = ./machines/edge/configuration.nix;
          };
          thamiel = nixosSystem {
            module = ./machines/thamiel/configuration.nix;
          };
          ithaca = nixosSystem {
            arch = "aarch64";
            module = ./machines/ithaca/configuration.nix;
          };
          milky = nixosSystem {
            module = ./machines/milky/configuration.nix;
          };
          nathanda = nixosSystem {
            module = ./machines/nathanda/configuration.nix;
          };
        };
    };
}
