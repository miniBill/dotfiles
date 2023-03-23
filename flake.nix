# musnix https://github.com/musnix/musnix/archive/master.tar.gz
# nixos https://nixos.org/channels/nixos-22.11
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    musnix.url = github:musnix/musnix/master;
  };

  outputs = { self, nixpkgs }: {
    nixosConfiguration = {
      uriel = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./uriel/configuration.nix ];
      };
    };
  };
}
