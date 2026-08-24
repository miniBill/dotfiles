{ pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "quattrosi";
  home.homeDirectory = "/home/quattrosi";
  home.stateVersion = "26.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  systemd.user.services.quattrosi = {
    Service = {
      After = [ "network.target" ];
      WantedBy = [ "multi-user.target" ];
      ExecStart = "${pkgs.nodejs}/bin/node dist-server/server.mjs";
      WorkingDirectory = "/home/quattrosi/quattrosi";
      User = "quattrosi";
      Group = "quattrosi";
    };
  };
}
