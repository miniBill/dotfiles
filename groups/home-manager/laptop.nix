{
  services.swayidle = {
    enable = true;
    events.before-sleep = "hyprlock";
    timeouts = [
      {
        timeout = 180;
        command = "hyprlock";
      }
      {
        timeout = 300;
        command = "systemctl suspend";
      }
    ];
  };
}
