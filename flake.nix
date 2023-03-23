# musnix https://github.com/musnix/musnix/archive/master.tar.gz
# nixos https://nixos.org/channels/nixos-22.11
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    musnix.url = github:musnix/musnix;
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
