let
  vid = "0665";
  pid = "5161";
  upsname = "Trustino";
  # pass-master = "masterMonitorPassword"; # master password for nut
  # pass-local = "localMonitorPassword"; # slave/local password for nut
in
{
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="${vid}", ATTRS{idProduct}=="${pid}", MODE="664", GROUP="wheel", OWNER="root" SYMLINK+="usb/ups"
  '';

  # at some point something will make a /var/state/ups directory,
  # chown that to nut:
  # $ sudo chown nut:nut /var/state/ups
  # power.ups = {
  #   enable = true;
  #   mode = "standalone";
  #   schedulerRules = "/etc/nixos/.config/nut/upssched.conf";
  #   # debug by calling the driver:
  #   # $ sudo NUT_CONFPATH=/etc/nut/ usbhid-ups -u nut -D -a apcsmx1500-a
  #   ups."${upsname}" = {
  #     # find your driver here:
  #     # https://networkupstools.org/docs/man/usbhid-ups.html
  #     driver = "usbhid-ups";
  #     description = "Trust UPS";
  #     port = "auto";
  #     directives = [
  #       "vendorid = ${vid}"
  #       "productid = ${pid}"
  #       "user = nut"
  #       "group = nut"
  #       "explore"
  #       # "ignorelb"
  #       # "override.battery.charge.low = 50"
  #       # "override.battery.runtime.low = 1200"
  #     ];
  #     # this option is not valid for usbhid-ups
  #     maxStartDelay = null;
  #   };
  #   maxStartDelay = 30;
  # };

  # users = {
  #   users.nut = {
  #     isSystemUser = true;
  #     group = "nut";
  #     # it does not seem to do anything with this directory
  #     # but something errored without it, so whatever
  #     home = "/var/lib/nut";
  #     createHome = true;
  #   };
  #   groups.nut = { };
  # };

  # services.udev.extraRules = ''
  #   SUBSYSTEM=="usb", ATTRS{idVendor}=="${vid}", ATTRS{idProduct}=="${pid}", MODE="664", GROUP="nut", OWNER="nut" SYMLINK+="usb/ups"
  # '';

  # systemd.services.upsd.serviceConfig = {
  #   User = "nut";
  #   Group = "nut";
  # };

  # systemd.services.upsdrv.serviceConfig = {
  #   User = "nut";
  #   Group = "nut";
  # };

  # reference: https://github.com/networkupstools/nut/tree/master/conf
  # environment.etc = {
  #   # tells upsd to listen on local network (0.0.0.0) for client machines
  #   upsdConf = {
  #     text = ''
  #       LISTEN 127.0.0.1 3493
  #     '';
  #     target = "nut/upsd.conf";
  #     mode = "0440";
  #     group = "nut";
  #     user = "nut";
  #   };
  #   upsdUsers = {
  #     # update upsmonConf MONITOR to match
  #     text = ''
  #       [monmaster]
  #           password = "${pass-master}"
  #           upsmon master

  #       [monslave]
  #           password = "${pass-local}"
  #           upsmon slave
  #     '';
  #     target = "nut/upsd.users";
  #     mode = "0440";
  #     group = "nut";
  #     user = "nut";
  #   };
  #   # RUN_AS_USER is not a default
  #   # the rest are from the sample
  #   # grep -v '#' /nix/store/8nciysgqi7kmbibd8v31jrdk93qdan3a-nut-2.7.4/etc/upsmon.conf.sample
  #   upsmonConf = {
  #     text = ''
  #       MONITOR ${upsname}@127.0.0.1 1 monmaster "${pass-master}" master

  #       RUN_AS_USER nut

  #       MINSUPPLIES 1
  #       SHUTDOWNCMD "/run/current-system/sw/bin/shutdown -h +0"
  #       NOTIFYCMD /run/current-system/sw/bin/upssched
  #       POLLFREQ 5
  #       POLLFREQALERT 5
  #       HOSTSYNC 15
  #       DEADTIME 15
  #       POWERDOWNFLAG /etc/killpower

  #       NOTIFYMSG ONLINE  "UPS %s on line power"
  #       NOTIFYMSG ONBATT  "UPS %s on battery"
  #       NOTIFYMSG LOWBATT "UPS %s battery is low"
  #       NOTIFYMSG FSD   "UPS %s: forced shutdown in progress"
  #       NOTIFYMSG COMMOK  "Communications with UPS %s established"
  #       NOTIFYMSG COMMBAD "Communications with UPS %s lost"
  #       NOTIFYMSG SHUTDOWN  "Auto logout and shutdown proceeding"
  #       NOTIFYMSG REPLBATT  "UPS %s battery needs to be replaced"
  #       NOTIFYMSG NOCOMM  "UPS %s is unavailable"
  #       NOTIFYMSG NOPARENT  "upsmon parent process died - shutdown impossible"

  #       NOTIFYFLAG ONLINE SYSLOG+WALL+EXEC
  #       NOTIFYFLAG ONBATT SYSLOG+WALL+EXEC
  #       NOTIFYFLAG LOWBATT  SYSLOG+WALL+EXEC
  #       NOTIFYFLAG FSD    SYSLOG+WALL+EXEC
  #       NOTIFYFLAG COMMOK SYSLOG+WALL+EXEC
  #       NOTIFYFLAG COMMBAD  SYSLOG+WALL+EXEC
  #       NOTIFYFLAG SHUTDOWN SYSLOG+WALL+EXEC
  #       NOTIFYFLAG REPLBATT SYSLOG+WALL+EXEC
  #       NOTIFYFLAG NOCOMM SYSLOG+WALL+EXEC
  #       NOTIFYFLAG NOPARENT SYSLOG+WALL

  #       RBWARNTIME 43200

  #       NOCOMMWARNTIME 300

  #       FINALDELAY 5
  #     '';
  #     target = "nut/upsmon.conf";
  #     mode = "0444";
  #     group = "nut";
  #     user = "nut";
  #   };
  # };
}
