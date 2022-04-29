{ config, pkgs, ... }:

{
  imports = [ ../groups/base.nix ];

  home.packages = with pkgs; [
  ];
}
