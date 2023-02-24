{ config
, pkgs
  # , pinned-unstable-discord
  # , pinned-unstable-tdesktop
, ...
}:

{
  imports = [ ../groups/graphical.nix ];

  home.packages = with pkgs; [
    rust-script
    # Im
    # pinned-unstable-discord.discord
    # pinned-unstable-tdesktop.tdesktop
  ];
}
