{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    roc = {
      url = "github:roc-lang/roc";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.nixgl.follows = "nixgl";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # vscode 1.83.1
    # pinned-unstable-vscode.url = "github:NixOS/nixpkgs?rev=ad425c0caf8b588d7296393c629481f22fecd00b";

    # elm-format 0.8.7
    # pinned-unstable-elm-format.url = "github:NixOS/nixpkgs?rev=a7f2c2c93968445b88584847a48be245f8fd0a08";
  };

  outputs =
    { nixpkgs
    , home-manager
      # , pinned-unstable-vscode
    , ...
    }@inputs:
    let
      withConfig =
        { system
        , username ? "minibill"
        , module
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
                "code"
                "discord"
                "google-chrome"
                "lamdera"
                "minecraft-launcher"
                "skypeforlinux"
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
            # pinned-unstable-vscode = import pinned-unstable-vscode {
            #   inherit system;
            #   config = {
            #     allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
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
