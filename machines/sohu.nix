{ config
, pkgs
  # , pinned-unstable-discord
  # , pinned-unstable-tdesktop
, ...
}:

{
  imports = [ ../groups/graphical.nix ];

  home.packages = with pkgs; [
    # Im
    # pinned-unstable-discord.discord
    # pinned-unstable-tdesktop.tdesktop
  ];
}
