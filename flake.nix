{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    roc.url = github:roc-lang/roc;

    # vscode 1.76.0
    pinned-unstable-vscode.url = "github:NixOS/nixpkgs?rev=9c3b025931e19ddf3f67a8cc8502cfecace58ace";

    # elm-format 0.8.7
    pinned-unstable-elm-format.url = "github:NixOS/nixpkgs?rev=a7f2c2c93968445b88584847a48be245f8fd0a08";
  };

  outputs =
    { nixpkgs
    , home-manager
    , pinned-unstable-vscode
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
                # Needed for nixops
                "python2.7-certifi-2021.10.8"
                "python2.7-pyjwt-1.7.1"
              ];
            };
          };
          modules = [ module ];
          extraSpecialArgs = inputs // {
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
