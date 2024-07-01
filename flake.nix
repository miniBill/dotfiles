{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-24.05-small";
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
  };

  outputs = { nixpkgs, ... } @ attrs: {
    nixosConfigurations = {
      uriel = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [ ./uriel/configuration.nix ];
      };
      sohu = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = attrs;
        modules = [ ./sohu/configuration.nix ];
      };
      tharmas = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [ ./tharmas/configuration.nix ];
      };
      thamiel = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [ ./thamiel/configuration.nix ];
      };
      ithaca = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = attrs;
        modules = [ ./ithaca/configuration.nix ];
      };
    };
  };
}
