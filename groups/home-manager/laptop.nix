{ pkgs, ... }:

{
  services.swayidle.timeouts = [
    {
      timeout = 180;
      command = pkgs.lib.getExe pkgs.hyprlock;
    }
    {
      timeout = 300;
      command = "systemctl suspend";
    }
  ];
}
