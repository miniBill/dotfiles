{ config, pkgs, ... }:

let
  pinned-unstable-calibre = import ../repos/pinned-unstable-calibre.nix;
  pinned-unstable-youtube-dl = import ../repos/pinned-unstable-youtube-dl.nix;
  pinned-unstable-discord = import ../repos/pinned-unstable-discord.nix;
  pinned-unstable-tdesktop = import ../repos/pinned-unstable-tdesktop.nix;
in
{
  imports = [ ../groups/graphical.nix ];

  home.packages = with pkgs; [
    # pinned-unstable-calibre.calibre
    libreoffice-fresh

    # NET
    # pinned-unstable-youtube-dl.youtubeDL

    # Im
    # pinned-unstable-discord.discord
    # pinned-unstable-tdesktop.tdesktop
  ];
}
