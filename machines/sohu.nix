{ config, pkgs, ... }:

{
  imports = [ ../groups/graphical.nix ];

  home.packages = with pkgs; [ ];
}
