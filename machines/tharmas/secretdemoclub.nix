{
  secretdemoclub,
  config,
  pkgs,
  ...
}:

let
  daemon = secretdemoclub.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  age.secrets.sdcConf = {
    file = ../../secrets/secretdemoclub.toml.age;
    owner = "sdc";
    group = "sdc";
  };

  systemd.services.secretdemoclub = {
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${daemon}/bin/secretdemoclub-server --config ${config.age.secrets.sdcConf.path}";
      User = "sdc";
      Group = "sdc";
    };
  };

  users = {
    users.sdc = {
      isSystemUser = true;
      group = "sdc";
      createHome = true;
    };
    groups.sdc = { };
  };
}
