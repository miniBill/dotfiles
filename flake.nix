{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # vscode 1.76.0
    pinned-unstable-vscode.url = "github:nixos/nixpkgs?rev=9c3b025931e19ddf3f67a8cc8502cfecace58ace";
  };

  outputs =
    { nixpkgs
    , home-manager
    , pinned-unstable-vscode
    , ...
    }:
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

                # Needed for rustdesk
                "libsciter"
              ];
              permittedInsecurePackages = [
                # Needed for nixops
                "python2.7-certifi-2021.10.8"
                "python2.7-pyjwt-1.7.1"
              ];
            };
          };
          modules = [ module ];
          extraSpecialArgs = {
            username = username;
            pinned-unstable-vscode = import pinned-unstable-vscode {
              inherit system;
              config = {
                allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
                  "code"
                  "vscode"
                ];
              };
            };
          };
        };
    in
    {
      defaultPackage = {
        "x86_64-darwin" = home-manager.defaultPackage.x86_64-darwin;
        "x86_64-linux" = home-manager.defaultPackage.x86_64-linux;
        "aarch64-darwin" = home-manager.defaultPackage.aarch64-darwin;
        "aarch64-linux" = home-manager.defaultPackage.aarch64-linux;
      };

      homeConfigurations = {
        "minibill@uriel" = withConfig {
          system = "x86_64-linux";
          module = ./machines/uriel.nix;
        };
        "leonardotaglialegne@VNDR-A406" = withConfig {
          system = "aarch64-darwin";
          username = "leonardotaglialegne";
          module = ./machines/gadiriel.nix;
        };
        "minibill@sohu" = withConfig {
          system = "aarch64-linux";
          module = ./machines/sohu.nix;
        };
      };
    };
}
