{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    musnix.url = github:musnix/musnix;
    inputs.agenix.url = "github:ryantm/agenix";
    # nixpkgs-unstable.url = "nixpkgs/nixos-unstable"; 
  };

  outputs = { self, nixpkgs, ... } @ attrs: {
    nixosConfigurations = {
      uriel = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [ ./uriel/configuration.nix ];
      };
    };
  };
}
