{ config, pkgs, ... }:

let
  pinned-unstable-discord = import ../repos/pinned-unstable-discord.nix;
  pinned-unstable-tdesktop = import ../repos/pinned-unstable-tdesktop.nix;
in
{
  imports = [ ../groups/graphical.nix ];

  home.packages = with pkgs; [
    # Im
    # pinned-unstable-discord.discord
    # pinned-unstable-tdesktop.tdesktop
  ];
}
