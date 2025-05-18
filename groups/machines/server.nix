_:

{
  # Internationalization
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "en_GB.UTF-8"
      "en_US.UTF-8"
    ];
  };
  time.timeZone = "UTC";

  services.openssh = {
    ports = [ 22 2222 ];
  };

  services.cron.enable = true;
}
