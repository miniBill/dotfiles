{ config, pkgs, ... }:
{
  imports = [ ./machine-base.nix ];

  programs = {
    zsh.initExtra = ''
      . /home/minibill/.nix-profile/etc/profile.d/nix.sh
    '';
  };
}
