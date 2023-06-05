{ ... }:

{
  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };
  time.timeZone = "UTC";

  services.cron.enable = true;
}
