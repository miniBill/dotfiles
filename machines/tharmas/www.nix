{
  pkgs,
  config,
  lib,
  ...
}:
let
  standardListen = [
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
      "taglialegne.it" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ ];
        listen = standardListen;
        root = "/var/www/tharmas";
      };
      "tharmas.taglialegne.it" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ ];
        listen = standardListen;
        root = "/var/www/tharmas";
      };
      "secretdemoclub.com" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "www.secretdemoclub.com" ];
        listen = standardListen;
        locations."/".proxyPass = "http://localhost:3000/";
      };
      "orla-player.taglialegne.it" = {
        forceSSL = true;
        enableACME = true;
        locations."/rss/orlagartland" = {
          proxyPass = "https://www.patreon.com/rss/orlagartland";
          extraConfig = "proxy_set_header Host www.patreon.com;";
        };
        listen = standardListen;
        root = "/var/www/orla-player";
      };
      "emilywelbers.com" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "www.emilywelbers.com" ];
        listen = standardListen;
        root = "/var/www/emilywelbers";
      };
      "fairyrings.emilywelbers.com" = {
        forceSSL = true;
        enableACME = true;
        # serverAliases = [ ];
        listen = standardListen;
        root = "/var/www/fairy-rings";
        # extraConfig = ''
        #   add_header X-Frame-Options SAMEORIGIN;
        # '';
      };
      "video.emilywelbers.com" = {
        forceSSL = true;
        enableACME = true;
        # serverAliases = [ ];
        listen = standardListen;
        root = "/var/www/video";
      };
      # "snizzo.taglialegne.it" = {
      #   locations."/".proxyPass = "http://127.0.0.1:8080/";
      # };
    };
  };
}
