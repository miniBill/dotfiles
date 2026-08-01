{ config, ... }:

{
  xdg.configFile."waybar/media_player.py".source = ./media_player.py;
  xdg.configFile."waybar/power_menu.xml".source = ./power_menu.xml;

  programs.waybar.enable = true; # launch on startup in the default setting (bar)
  programs.waybar.settings.mainBar = {
    # "layer" = "top"; # Waybar at top layer
    # "position" = "left"; # Waybar position (top|bottom|left|right)
    # "height" = 30; # Waybar height (to be removed for auto height)
    # "width" = 30; # Waybar width
    # "spacing" = 4; # Gaps between modules (4px)
    # Choose the order of the modules
    modules-left = [
      "niri/workspaces"
      "custom/media"
    ];
    modules-center = [
      "niri/window"
    ];
    modules-right = [
      "mpd"
      "idle_inhibitor"
      "pulseaudio"
      "network"
      "power-profiles-daemon"
      "cpu"
      "memory"
      "temperature"
      "backlight"
      # "keyboard-state"
      "battery"
      "clock"
      "tray"
      "custom/power"
    ];
    "niri/workspaces" = {
      # "format" = "{icon} {windows}";
      # "format-window-separator" = " ";
      # "window-rewrite-default" = "";
      # "window-rewrite" = {
      #   "app_id<firefox>" = "";
      #   "app_id<dolphin>" = "";
      #   "app_id<org.gnome.Nautilus>" = "";
      #   "app_id<thunar>" = "";
      #   "app_id<foot>" = "";
      # };
      # "format-icons" = {
      #   "1" = "1";
      #   # "2" = "2";
      #   "3" = "3";
      #   "4" = "4";
      #   "5" = "5";
      #   "active" = "";
      #   "default" = "";
      # };
    };
    "niri/window" = {
      icon = true;
      separate-outputs = true;
      icon-size = 20;
    };
    mpd = {
      format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
      format-disconnected = "Disconnected ";
      format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
      unknown-tag = "N/A";
      interval = 5;
      consume-icons = {
        on = " ";
      };
      random-icons = {
        off = "<span color=\"#f53c3c\"></span> ";
        on = " ";
      };
      repeat-icons = {
        on = " ";
      };
      single-icons = {
        on = "1 ";
      };
      state-icons = {
        paused = "";
        playing = "";
      };
      tooltip-format = "MPD (connected)";
      tooltip-format-disconnected = "MPD (disconnected)";
    };
    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };
    tray = {
      # "icon-size"= 21;
      spacing = 10;
      # "icons"= {
      #   "blueman"= "bluetooth";
      #   "TelegramDesktop"= "${config.xdg.dataHome}/icons/hicolor/16x16/apps/telegram.png";
      # };
    };
    clock = {
      # "timezone"= "America/New_York";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = "{:%Y-%m-%d}";
    };
    cpu = {
      format = "{usage}% ";
      tooltip = false;
    };
    memory = {
      format = "{}% ";
    };
    temperature = {
      # "thermal-zone"= 2;
      # "hwmon-path"= "/sys/class/hwmon/hwmon2/temp1_input";
      critical-threshold = 80;
      # "format-critical"= "{temperatureC}°C {icon}";
      format = "{temperatureC}°C {icon}";
      format-icons = [
        "󰉬"
        ""
        "󰉪"
      ];
    };
    backlight = {
      # "device"= "acpi_video1";
      format = "{percent}% {icon}";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
      ];
    };
    battery = {
      states = {
        # "good"= 95;
        warning = 30;
        critical = 15;
      };
      format = "{capacity}% {icon}";
      format-full = "{capacity}% {icon}";
      format-charging = "{capacity}% 󰃨";
      format-plugged = "{capacity}% ";
      format-alt = "{time} {icon}";
      # "format-good"= ""; # An empty format will hide the module
      # "format-full"= "";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
    };
    power-profiles-daemon = {
      format = "{icon}";
      tooltip-format = "Power profile: {profile}\nCPU driver: {cpu_driver}\nPlatform driver: {platform_driver}";
      tooltip = true;
      format-icons = {
        default = "";
        performance = "";
        balanced = "";
        power-saver = "";
      };
    };
    network = {
      # interface = "wlp2*"; # (Optional) To force the use of this interface
      # format-wifi = "{essid} ({signalStrength}%) ";
      # format-wifi = "({signalStrength}%) ";
      format-ethernet = "{ipaddr}/{cidr} 󰊗";
      tooltip-format = "{ifname} via {gwaddr} 󰊗";
      format-linked = "{ifname} (No IP) 󰊗";
      format-disconnected = "Disconnected ⚠";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
    };
    pulseaudio = {
      # "scroll-step"= 1; # %; can be a float
      format = "{volume}% {icon} {format_source}";
      format-bluetooth = "{volume}% {icon} {format_source}";
      format-bluetooth-muted = "󰅶 {icon} {format_source}";
      format-muted = "󰅶 {format_source}";
      format-source = "{volume}% ";
      format-source-muted = "";
      format-icons = {
        headphone = "";
        hands-free = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [
          ""
          ""
          ""
        ];
      };
      on-click = "pavucontrol";
    };
    "custom/media" = {
      format = "{icon} {text}";
      return-type = "json";
      max-length = 40;
      format-icons = {
        spotify = "";
        default = "🎜";
      };
      escape = true;
      # exec = "${config.xdg.configHome}/waybar/media_player.py 2> /dev/null"; # Script in resources folder
      exec = "${config.xdg.configHome}/waybar/media_player.py --player spotify 2> /dev/null"; # Filter player based on name
    };
    "custom/power" = {
      format = " ⏻ ";
      tooltip = false;
      menu = "on-click";
      menu-file = "${config.xdg.configHome}/waybar/power_menu.xml"; # Menu file in resources folder
      menu-actions = {
        shutdown = "shutdown";
        reboot = "reboot";
        suspend = "systemctl suspend";
        hibernate = "systemctl hibernate";
      };
    };
  };
}
