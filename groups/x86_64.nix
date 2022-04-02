{ pkgs, ... }:

let
  pinned-unstable-vscode = import ../repos/pinned-unstable-vscode.nix;
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

  programs = {
    vscode.package = pinned-unstable-vscode.vscode-fhsWithPackages (ps: with ps; [ desktop-file-utils gnome3.gnome-keyring ]);
  };
}
