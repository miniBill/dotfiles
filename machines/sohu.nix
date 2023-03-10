{ config
, pkgs
  # , pinned-unstable-discord
, ...
}:

{
  imports = [ ../groups/graphical.nix ];

  home.packages = with pkgs; [
    # Im
    # pinned-unstable-discord.discord
  ];
}
