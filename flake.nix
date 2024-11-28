{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    # nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-24.05-small";
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

  outputs = inputs: {
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
