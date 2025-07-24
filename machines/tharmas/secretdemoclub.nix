{ secretdemoclub, pkgs, ... }:

let
  daemon = secretdemoclub.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  systemd.services.secretdemoclub = {
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${daemon}/bin/secretdemoclub-server";
    };
  };
}
