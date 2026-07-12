{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  imports = [ ./waybar.nix ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
  xdg.configFile."waybar/media_player.py".source = ./media_player.py;
  xdg.configFile."waybar/power_menu.xml".source = ./power_menu.xml;
  programs = {
    alacritty.enable = true; # Super+T in the default setting (terminal)
    fuzzel.enable = true; # Super+D in the default setting (app launcher)
    swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
  };
  services = {
    mako.enable = true; # notification daemon
    swayidle.enable = true; # idle management daemon
    polkit-gnome.enable = true; # polkit
  };
  home.packages = with pkgs; [
    swaybg # wallpaper
    xwayland-satellite # xwayland support
  ];
}
