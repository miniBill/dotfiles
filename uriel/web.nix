{ pkgs, lib, config, ... }:
let
  app = "casa";
  domain = "${app}.taglialegne.it";
  dataDir = "/srv/http/${domain}";
in
{
  security.acme = {
    acceptTerms = true;
    email = "leonardo@taglialegne.it";
  };

  services.phpfpm.pools.${app} = {
    user = app;
    phpOptions = ''
      upload_max_filesize = 400M
      post_max_size = 400M
    '';
    settings = {
      "listen.owner" = config.services.nginx.user;
      "listen.group" = config.services.nginx.group;
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.max_requests" = 500;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 5;
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
    };
    phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
  };
  services.nginx = {
    enable = true;
    virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;
      listen = [
        { addr = "0.0.0.0"; port = 80; }
        { addr = "0.0.0.0"; port = 443; ssl = true; }
      ];
      root = dataDir;

      extraConfig = ''
        # Maximum file upload size is 4MB - change accordingly if needed
        client_max_body_size 400M;
        client_body_buffer_size 128k;

        location ~ \.php$ {
          fastcgi_index index.php;
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          fastcgi_pass unix:${config.services.phpfpm.pools.${app}.socket};
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
          fastcgi_param PATH_INFO       $fastcgi_path_info;
          fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
          # Mitigate https://httpoxy.org/ vulnerabilities
          fastcgi_param HTTP_PROXY "";
          fastcgi_intercept_errors off;
          fastcgi_buffer_size 16k;
          fastcgi_buffers 4 16k;
          fastcgi_connect_timeout 300;
          fastcgi_send_timeout 300;
          fastcgi_read_timeout 300;
        }
      '';
    };
  };
  users.users.${app} = {
    isSystemUser = true;
    createHome = true;
    home = dataDir;
    group = app;
  };
  users.groups.${app} = { };
}
