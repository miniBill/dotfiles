{ config, pkgs, ... }:

{
  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  security.pam.services.kwallet.enableKwallet = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Used by vscode, parcel and friends
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [ gparted kwin ];

  # Hardware
  hardware.keyboard.zsa.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable smart card reader
  services.pcscd.enable = true;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };
}
