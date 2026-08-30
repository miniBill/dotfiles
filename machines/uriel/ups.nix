{ config, ... }:
let
  vid = "0665";
  pid = "5161";
  upsname = "Trustino";
in
{
  # services.udev.extraRules = ''
  #   SUBSYSTEM=="usb", ATTRS{idVendor}=="${vid}", ATTRS{idProduct}=="${pid}", MODE="664", GROUP="nut", OWNER="nut" SYMLINK+="usb/ups"
  # '';

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="${vid}", ATTRS{idProduct}=="${pid}", MODE="664", GROUP="nutmon", OWNER="nutmon", SYMLINK+="usb/ups"
  '';

  age.secrets.nut-password = {
    file = ../../secrets/nut-password.age;
    owner = "nutmon";
    group = "nutmon";
  };

  systemd.services.upsd.serviceConfig = {
    User = "nutmon";
    Group = "nutmon";
  };

  systemd.services.upsdrv.serviceConfig = {
    User = "nutmon";
    Group = "nutmon";
  };

  systemd.user.tmpfiles.rules = [
    "d /run/nut 700 nutmon nutmon"
    "d /var/lib/nut 700 nutmon nutmon"
  ];

  power.ups = {
    enable = true;
    mode = "standalone";
    # schedulerRules = "/etc/nixos/.config/nut/upssched.conf";
    # debug by calling the driver:
    # $ sudo env NUT_CONFPATH=/etc/nut/ nutdrv_qx -D -a Trustino -u nutmon
    ups."${upsname}" = {
      description = "Trust UPS";

      # driver name from https://networkupstools.org/stable-hcl.html
      driver = "nutdrv_qx";
      port = "auto";

      directives = [
        "vendorid = ${vid}"
        "productid = ${pid}"
        # "user = nut"
        # "group = nut"
        # "explore"
        "offdelay = 60"

        # This must be more than offdelay
        "ondelay = 70"

        # Set value for battery.charge.low. Upsmon initiate shutdown once this threshold is reached.
        # "lowbatt = 40"

        # Ignore it if the UPS reports a low battery condition.
        # Without this, system will shutdown only when ups reports lb, not respecting lowbatt option
        # "ignorelb"
      ];
      # this option is not valid for nutdrv_qx
      # maxStartDelay = null;
    };
    # maxStartDelay = 30;
    upsd = {
      listen = [
        {
          address = "127.0.0.1";
          port = 3493;
        }
        {
          address = "::1";
          port = 3493;
        }
      ];
    };
    users."nut-admin" = {
      # A file that contains just the password.
      passwordFile = config.age.secrets.nut-password.path;
      upsmon = "primary";
    };
    upsmon.monitor."${upsname}" = {
      system = "${upsname}@localhost";
      powerValue = 1;
      user = "nut-admin";
      passwordFile = config.age.secrets.nut-password.path;
      type = "primary";
    };
    upsmon.settings = {
      # This configuration file declares how upsmon is to handle
      # NOTIFY events.

      # POWERDOWNFLAG and SHUTDOWNCMD is provided by NixOS default
      # values

      # values provided by ConfigExamples 3.0 book
      NOTIFYMSG = [
        [
          "ONLINE"
          ''"UPS %s: On line power."''
        ]
        [
          "ONBATT"
          ''"UPS %s: On battery."''
        ]
        [
          "LOWBATT"
          ''"UPS %s: Battery is low."''
        ]
        [
          "REPLBATT"
          ''"UPS %s: Battery needs to be replaced."''
        ]
        [
          "FSD"
          ''"UPS %s: Forced shutdown in progress."''
        ]
        [
          "SHUTDOWN"
          ''"Auto logout and shutdown proceeding."''
        ]
        [
          "COMMOK"
          ''"UPS %s: Communications (re-)established."''
        ]
        [
          "COMMBAD"
          ''"UPS %s: Communications lost."''
        ]
        [
          "NOCOMM"
          ''"UPS %s: Not available."''
        ]
        [
          "NOPARENT"
          ''"upsmon parent dead, shutdown impossible."''
        ]
      ];
      NOTIFYFLAG = [
        [
          "ONLINE"
          "SYSLOG+WALL"
        ]
        [
          "ONBATT"
          "SYSLOG+WALL"
        ]
        [
          "LOWBATT"
          "SYSLOG+WALL"
        ]
        [
          "REPLBATT"
          "SYSLOG+WALL"
        ]
        [
          "FSD"
          "SYSLOG+WALL"
        ]
        [
          "SHUTDOWN"
          "SYSLOG+WALL"
        ]
        [
          "COMMOK"
          "SYSLOG+WALL"
        ]
        [
          "COMMBAD"
          "SYSLOG+WALL"
        ]
        [
          "NOCOMM"
          "SYSLOG+WALL"
        ]
        [
          "NOPARENT"
          "SYSLOG+WALL"
        ]
      ];
      # every RBWARNTIME seconds, upsmon will generate a replace
      # battery NOTIFY event
      # RBWARNTIME = 216000;
      # every NOCOMMWARNTIME seconds, upsmon will generate a UPS
      # unreachable NOTIFY event
      NOCOMMWARNTIME = 300;
      # after sending SHUTDOWN NOTIFY event to warn users, upsmon
      # waits FINALDELAY seconds long before executing SHUTDOWNCMD
      # Some UPS's don't give much warning for low battery and will
      # require a value of 0 here for aq safe shutdown.
      FINALDELAY = 0;
    };
  };
}
