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

  programs.alacritty.enable = true; # Super+T in the default setting (terminal)
  programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)

  programs.hyprlock.enable = true;
  programs.hyprlock.settings = {
    general.hide_cursor = false;

    auth.fingerprint = {
      enabled = true;
      retry_delay = 250; # in milliseconds
    };

    background.path = "~/Pictures/Wallpapers/Witch.jpg";

    input-field = {
      size = "20%, 5%";
      outline_thickness = "3";
      inner_color = "rgba(0, 0, 0, 0.0)"; # no fill

      outer_color = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
      fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";

      font_color = "rgb(143, 143, 143)";
      fade_on_empty = "false";
      rounding = "15";

      placeholder_text = "Input password...";
      fail_text = "$PAMFAIL$FPRINTFAIL";

      # uncomment if you wish to display a message during authentication;
      check_text = "Authenticating...";

      # uncomment to use a letter instead of a dot to indicate the typed password;
      # dots_text_format = "*";
      # dots_size = 0.4;
      dots_spacing = "0.3";

      # uncomment to use an input indicator that does not show the password length (similar to swaylock's input indicator);
      # hide_input = true;

      # position = "0, -20";
      halign = "center";
      valign = "center";
    };

    label = [
      #  TIME
      {
        text = "$TIME"; # ref. https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/#variable-substitution
        font_size = 90;

        position = "-30, 0";
        halign = "right";
        valign = "top";
      }

      #  DATE
      {
        text = "cmd[update:60000] date +\"%A, %d %B %Y\""; # update every 60 seconds
        font_size = 25;

        position = "-30, -150";
        halign = "right";
        valign = "top";
      }
    ];
  };

  services.swayidle = {
    enable = true;
    events.before-sleep = "hyprlock";
  };

  services.mako.enable = true; # notification daemon
  services.polkit-gnome.enable = true; # polkit

  home.packages = with pkgs; [
    nirius # focus-or-spawn
    wpaperd # wallpaper
    xwayland-satellite # xwayland support
  ];
}
