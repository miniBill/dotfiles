{ config, pkgs, ... }:

{
  imports = [ ../groups/graphical.nix ];

  home.packages = with pkgs; [
    rust-script
  ];

  programs.git.userEmail = "leonardo.taglialegne@vendr.com";
}
