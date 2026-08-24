{
  config,
  pkgs,
  ...
}:

{
  systemd.services.quattrosi = {
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nodejs}/bin/node dist-server/server.mjs";
      WorkingDirectory = "/home/quattrosi/quattrosi";
      User = "quattrosi";
      Group = "quattrosi";
    };
  };

  services.nginx.virtualHosts."quattrosi.taglialegne.it" = {
    forceSSL = true;
    enableACME = true;
    listen = [
      {
        addr = "0.0.0.0";
        port = 80;
      }
      {
        addr = "127.0.0.1";
        port = 443;
        ssl = true;
      }
    ];
    locations."/".proxyPass = "http://localhost:3001/";
  };

  users = {
    users.quattrosi = {
      isNormalUser = true;
      shell = pkgs.zsh;
      group = "quattrosi";
      createHome = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGAVCUqG9wVONKAUB449Zn+B/6nbKPFOlCcyCC55u3K minibill@uriel"
      ];
    };
    groups.quattrosi = { };
  };
}
