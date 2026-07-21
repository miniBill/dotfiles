{
  pkgs,
  lib,
  config,
  username,
  ...
}:
let
  validated-niri-config =
    pkgs.runCommand "niri-config-checked"
      {
        nativeBuildInputs = [ pkgs.niri ];
      }
      ''
        niri validate --config ${./config.kdl}
        cp ${./config.kdl} $out
      '';
in
{
  imports = [ ./waybar.nix ];

  xdg.configFile."niri/config.kdl".source = validated-niri-config;
  xdg.configFile."waybar/media_player.py".source = ./media_player.py;
  xdg.configFile."waybar/power_menu.xml".source = ./power_menu.xml;
  xdg.configFile."wpaperd/config.toml".source = ./wpaperd-config.toml;
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
    nirius # focus-or-spawn
    wpaperd # wallpaper
    xwayland-satellite # xwayland support
  ];
}
