{
  services.swayidle.timeouts = [
    {
      timeout = 180;
      command = "hyprlock";
    }
    {
      timeout = 300;
      command = "systemctl suspend";
    }
  ];
}
