{ pkgs, ... }:

let
  pinned-unstable-zoom = import ../repos/pinned-unstable-zoom.nix;
in
{
  home = {
    packages = with pkgs; [
      etcher
      spotify
      pinned-unstable-zoom.zoom-us

      (callPackage ../programs/lamdera.nix { })
    ];
  };

  programs = { };
}
