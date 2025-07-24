{ lib, ... }:

{
  systemd.services.secretdemoclub = {
    enable = true;
    name = "SDC HQ OMG BBQ";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = { 
      ExecStart = "${daemon}/bin/secretdemoclub"
    };
  };
}
