{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pinned-unstable-calibre.url = "github:nixos/nixpkgs?rev=1657c3114e93d380dc54441a8ae2ecdf5840ab31";
    pinned-unstable-discord.url = "github:nixos/nixpkgs?rev=eeca5969b3f42ac943639aaec503816f053e5e53";
    pinned-unstable-piper.url = "github:nixos/nixpkgs?rev=d92383b18de4ec74807e740054ff00e2a3b8bcd9";

    # vscode 1.75.1
    pinned-unstable-vscode.url = "github:nixos/nixpkgs?rev=47301c257adf2e479d9ef810d92aa1aa2a7df0b5";
  };

  outputs =
    { nixpkgs
    , home-manager
    , pinned-unstable-calibre
    , pinned-unstable-discord
    , pinned-unstable-piper
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
            pinned-unstable-calibre = import pinned-unstable-calibre { inherit system; };
            pinned-unstable-discord = import pinned-unstable-discord { inherit system; };
            pinned-unstable-piper = import pinned-unstable-piper { inherit system; };
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
