# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Breeze-Dark";
      icon-theme = "breeze-dark";
      monospace-font-name = "FiraCode Nerd Font  10";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Breeze-Dark";
    };
  };
}
