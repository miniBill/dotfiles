{ pkgs, config, lib, ... }:
{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    commonHttpConfig = ''
      resolver 1.1.1.1;

      # Add HSTS header with preloading to HTTPS requests.
      # Adding this header to HTTP requests is discouraged
      map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;

      # Enable CSP for your services.
      #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

      # Minimize information leaked to other domains
      add_header 'Referrer-Policy' 'origin-when-cross-origin';

      # Disable embedding as a frame
      add_header X-Frame-Options DENY;

      # Prevent injection of code in other mime types (XSS Attacks)
      add_header X-Content-Type-Options nosniff;

      # Enable XSS protection of the browser.
      # May be unnecessary when CSP is configured properly (see above)
      add_header X-XSS-Protection "1; mode=block";

      # This might create errors
      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';

    virtualHosts = {
      "latisanalingue.it" = {
        onlySSL = true;
        enableACME = true;
        serverAliases = [ "www.latisanalingue.it" ];
        listen = [
          { addr = "0.0.0.0"; port = 80; }
          { addr = "127.0.0.1"; port = 443; ssl = true; }
        ];
        root = "/var/www/latisanalingue";
        extraConfig = "index index.php;";
        locations."/" = {
          tryFiles = "$uri $uri/ /index.php?$args";
        };
        locations."~ \\.php$" = {
          extraConfig = ''
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_index index.php;
            fastcgi_pass unix:${config.services.phpfpm.pools.latisanalingue.socket};
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
          '';
        };
        locations."~ \\.(js|css|png|jpg|gif|swf|woff|ttf|ico|pdf|mov|fla|zip|rar)$" = {
          tryFiles = "$uri =404";
        };
        # locations."~ ^/https://?www.patreon.com/([^\\r\\n]*)$" = {
        #   extraConfig = ''
        #     proxy_pass https://www.patreon.com/$1$is_args$args;
        #     proxy_hide_header Access-Control-Allow-Origin;
        #     proxy_set_header Host www.patreon.com;
        #     add_header Strict-Transport-Security $hsts_header;
        #     add_header 'Referrer-Policy' 'origin-when-cross-origin';
        #     add_header X-Frame-Options DENY;
        #     add_header X-Content-Type-Options nosniff;
        #     add_header X-XSS-Protection "1; mode=block";
        #     add_header 'Access-Control-Allow-Origin' $http_origin always;
        #     add_header 'Access-Control-Allow-Headers' 'Authorization,Accept,Origin,DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range';
        #     add_header 'Access-Control-Allow-Methods' 'GET,POST,OPTIONS,PUT,DELETE,PATCH';
        #   '';
        # };
        # locations."~ ^/https://?([a-z0-9]*).patreonusercontent.com/([^\\r\\n]*)$" = {
        #   extraConfig = ''
        #     proxy_pass https://$1.patreonusercontent.com/$2$is_args$args;
        #     proxy_hide_header Access-Control-Allow-Origin;
        #     proxy_set_header Host $1.patreonusercontent.com;
        #     add_header Strict-Transport-Security $hsts_header;
        #     add_header 'Referrer-Policy' 'origin-when-cross-origin';
        #     add_header X-Frame-Options DENY;
        #     add_header X-Content-Type-Options nosniff;
        #     add_header X-XSS-Protection "1; mode=block";
        #     add_header 'Access-Control-Allow-Origin' $http_origin always;
        #     add_header 'Access-Control-Allow-Headers' 'Authorization,Accept,Origin,DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range';
        #     add_header 'Access-Control-Allow-Methods' 'GET,POST,OPTIONS,PUT,DELETE,PATCH';
        #   '';
        # };
      };
      "snizzo.latisanalingue.it" = {
        locations."/".proxyPass = "http://127.0.0.1:8080/";
      };
    };
  };
  services.phpfpm.pools.latisanalingue = {
    user = "latisanalingue";
    settings = {
      "listen.owner" = "nginx";
      "listen.group" = "nginx";
      "pm" = "dynamic";
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 500;
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
    };
    phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
  };
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    bind = "127.0.0.1";
    ensureDatabases = [ "latisanalingue" ];
    ensureUsers = [{
      name = "latisanalingue";
      ensurePermissions = {
        "latisanalingue.*" = "ALL PRIVILEGES";
      };
    }];
  };
}
