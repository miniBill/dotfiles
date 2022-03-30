{ config, pkgs, ... }:

{
  # Networking
  networking.networkmanager.enable = true; # Enables NetworkManager
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = "ibus";
  };

  # Common software
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
  ];
}
