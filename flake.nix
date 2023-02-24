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
    pinned-unstable-tdesktop.url = "github:nixos/nixpkgs?rev=910b2be5ac08264311123d3add6d81e8e6fd05b8";
    maybe-qtcreator.url = "github:Artturin/nixpkgs?rev=2e523a3b38aa498942103e3957adef16ad697247";
  };

  outputs =
    { nixpkgs
    , home-manager
    , pinned-unstable-calibre
    , pinned-unstable-discord
    , pinned-unstable-piper
    , pinned-unstable-tdesktop
    , maybe-qtcreator
    , ...
    }:
    let
      withConfig = { arch, username, module }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${arch};
          modules = [ module ];
          extraSpecialArgs = {
            username = username;
            pinned-unstable-calibre = pinned-unstable-calibre.legacyPackages.${arch};
            pinned-unstable-discord = pinned-unstable-discord.legacyPackages.${arch};
            pinned-unstable-piper = pinned-unstable-piper.legacyPackages.${arch};
            pinned-unstable-tdesktop = pinned-unstable-tdesktop.legacyPackages.${arch};
            maybe-qtcreator = maybe-qtcreator.legacyPackages.${arch};
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
          arch = "x86_64-linux";
          username = "minibill";
          module = ./machines/uriel.nix;
        };
      };
    };
}