_:

{
  # Internationalization
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "en_GB.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };
  time.timeZone = "UTC";

  services.openssh = {
    ports = [
      22
      2222
    ];
  };

  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "1h";
    bantime-increment.enable = true;
    ignoreIP = [ ];
  };

  services.cron.enable = true;
}
