{
  pkgs,
  config,
  lib,
  ...
}:
let
  standardListen =
    cfg:
    {
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
    }
    // cfg;
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "leonardo@taglialegne.it";
  };

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
      # add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

      # Minimize information leaked to other domains
      add_header 'Referrer-Policy' 'origin-when-cross-origin';

      # Disable embedding as a frame
      # add_header X-Frame-Options DENY;

      # Prevent injection of code in other mime types (XSS Attacks)
      add_header X-Content-Type-Options nosniff;

      # Enable XSS protection of the browser.
      # May be unnecessary when CSP is configured properly (see above)
      add_header X-XSS-Protection "1; mode=block";

      # This might create errors
      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';

    virtualHosts = {
      "taglialegne.it" = standardListen {
        serverAliases = [ "tharmas.taglialegne.it" ];
        root = "/var/www/taglialegne.it";
      };
      "outline.taglialegne.it" = standardListen {
        locations."/" = {
          proxyPass = "http://localhost:3333";
          proxyWebsockets = true;
        };
      };
      "orla-player.taglialegne.it" = standardListen {
        locations."/rss/orlagartland" = {
          proxyPass = "https://www.patreon.com/rss/orlagartland";
          extraConfig = "proxy_set_header Host www.patreon.com;";
        };
        root = "/var/www/orla-player";
      };
      "witch-awakening.taglialegne.it" = standardListen {
        serverAliases = [ "witchawakening.taglialegne.it" ];
        root = "/var/www/witch-awakening.taglialegne.it";
      };
      "x.taglialegne.it" = standardListen {
        root = "/var/www/x";
      };
      # "snizzo.taglialegne.it" = standardListen {
      #   locations."/".proxyPass = "http://127.0.0.1:8080/";
      # };

      "secretdemoclub.com" = standardListen {
        serverAliases = [ "www.secretdemoclub.com" ];
        locations."/".proxyPass = "http://localhost:3000/";
      };

      "emilywelbers.com" = standardListen {
        serverAliases = [ "www.emilywelbers.com" ];
        root = "/var/www/emilywelbers.com";
        locations."/shop".return = "301 https://shop.emilywelbers.com";
      };

      "shop.emilywelbers.com" = standardListen {
        root = "/var/www/shop.emilywelbers.com";

        extraConfig = ''
          index index.php;

          # This should match the `post_max_size` and/or `upload_max_filesize` settings
          # in your php.ini.
          client_max_body_size 16M;

          # Redirect 404 errors to PrestaShop.
          error_page 404 /index.php?controller=404;

          rewrite ^/nl$ /nl/ redirect;
          rewrite ^/nl/(.*) /$1;
          rewrite ^/en$ /en/ redirect;
          rewrite ^/en/(.*) /$1;

          # Images.
          rewrite ^/(\d)(-[\w-]+)?/.+\.jpg$ /img/p/$1/$1$2.jpg last;
          rewrite ^/(\d)(\d)(-[\w-]+)?/.+\.jpg$ /img/p/$1/$2/$1$2$3.jpg last;
          rewrite ^/(\d)(\d)(\d)(-[\w-]+)?/.+\.jpg$ /img/p/$1/$2/$3/$1$2$3$4.jpg last;
          rewrite ^/(\d)(\d)(\d)(\d)(-[\w-]+)?/.+\.jpg$ /img/p/$1/$2/$3/$4/$1$2$3$4$5.jpg last;
          rewrite ^/(\d)(\d)(\d)(\d)(\d)(-[\w-]+)?/.+\.jpg$ /img/p/$1/$2/$3/$4/$5/$1$2$3$4$5$6.jpg last;
          rewrite ^/(\d)(\d)(\d)(\d)(\d)(\d)(-[\w-]+)?/.+\.jpg$ /img/p/$1/$2/$3/$4/$5/$6/$1$2$3$4$5$6$7.jpg last;
          rewrite ^/(\d)(\d)(\d)(\d)(\d)(\d)(\d)(-[\w-]+)?/.+\.jpg$ /img/p/$1/$2/$3/$4/$5/$6/$7/$1$2$3$4$5$6$7$8.jpg last;
          rewrite ^/(\d)(\d)(\d)(\d)(\d)(\d)(\d)(\d)(-[\w-]+)?/.+\.jpg$ /img/p/$1/$2/$3/$4/$5/$6/$7/$8/$1$2$3$4$5$6$7$8$9.jpg last;
          rewrite ^/c/([\w.-]+)/.+\.jpg$ /img/c/$1.jpg last;

          # AlphaImageLoader for IE and FancyBox.
          rewrite ^images_ie/?([^/]+)\.(gif|jpe?g|png)$ js/jquery/plugins/fancybox/images/$1.$2 last;

          # Web service API.
          rewrite ^/api/?(.*)$ /webservice/dispatcher.php?url=$1 last;

          # Installation sandbox.
          rewrite ^(/install(?:-dev)?/sandbox)/.* /$1/test.php last;

          location / {
            try_files $uri $uri/ /index.php$is_args$args;
          }

          location /admin/ {
            try_files $uri $uri/ /admin/index.php$is_args$args;
          }


          # .htaccess, .DS_Store, .htpasswd, etc.
          location ~ /\.(?!well-known) {
            deny all;
          }

          # Source code directories.
          location ~ ^/(app|bin|cache|classes|config|controllers|docs|localization|override|src|tests|tools|translations|var|vendor)/ {
            deny all;
          }

          # vendor in modules directory.
          location ~ ^/modules/.*/vendor/ {
            deny all;
          }

          # Prevent exposing other sensitive files.
          location ~ \.(log|tpl|twig|sass|yml)$ {
            deny all;
          }

          # Prevent injection of PHP files.
          location /img {
            location ~ \.php$ { deny all; }
          }

          location /upload {
            location ~ \.php$ { deny all; }
          }

          location ~ [^/]\.php(/|$) {
            # Split $uri to $fastcgi_script_name and $fastcgi_path_info.
            fastcgi_split_path_info ^(.+?\.php)(/.*)$;

            # Ensure that the requested PHP script exists before passing it
            # to the PHP-FPM.
            try_files $fastcgi_script_name =404;

            # Environment variables for PHP.
            include ${pkgs.nginx}/conf/fastcgi_params;
            include ${pkgs.nginx}/conf/fastcgi.conf;
            fastcgi_param SCRIPT_FILENAME $request_filename;

            fastcgi_index index.php;

            fastcgi_keep_conn on;
            fastcgi_read_timeout 300s;
            fastcgi_send_timeout 300s;

            # Uncomment these in case of long loading or 502/504 errors.
            # fastcgi_buffer_size 256k;
            # fastcgi_buffers 256 16k;
            # fastcgi_busy_buffers_size 256k;

            fastcgi_pass unix:${config.services.phpfpm.pools."shop.emilywelbers.com".socket};
          }
        '';
      };

      "fairyrings.emilywelbers.com" = standardListen {
        root = "/var/www/fairyrings.emilywelbers.com";
        # extraConfig = ''
        #   add_header X-Frame-Options SAMEORIGIN;
        # '';
      };
      "video.emilywelbers.com" = standardListen {
        root = "/var/www/video.emilywelbers.com";
      };
    };
  };

  services.phpfpm.pools."shop.emilywelbers.com" = {
    user = "emilywelbers";
    phpOptions = ''
      upload_max_filesize = 400M
      post_max_size = 400M
      max_execution_time = 400
      memory_limit = 1G
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

  environment.systemPackages = [
    (pkgs.php.buildEnv { extraConfig = "memory_limit = 1G"; })
  ];

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
}
