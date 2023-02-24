{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      withConfig = { arch, username }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${arch};
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            username = username;
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
        "miniBill@uriel" = withConfig { arch = "x86_64-linux"; username = "minibill"; };
      };
    };
}
