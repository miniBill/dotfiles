{ config, ... }:
{
  age.secrets.cjdnsConf = {
    file = ../../secrets/cjdroute.conf.age;
    owner = "root";
    group = "root";
  };
  services.cjdns = {
    enable = true;
    confFile = config.age.secrets.cjdnsConf.path;
  };
}
