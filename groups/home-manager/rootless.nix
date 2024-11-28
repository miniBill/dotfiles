{ ... }:

{
  imports = [ ./base.nix ];

  programs = {
    zsh.initExtra = ''
      . $HOME/.nix-profile/etc/profile.d/nix.sh
    '';
  };
}
