{ config
, pkgs
  # , pinned-unstable-discord
, ...
}:

{
  imports = [ ../groups/graphical.nix ];

  home.packages = with pkgs; [
    rust-script
    # Im
    # pinned-unstable-discord.discord
  ];

  programs.git.userEmail = "leonardo.taglialegne@vendr.com";
}
