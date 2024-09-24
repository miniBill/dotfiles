{ pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.openssh.settings.X11Forwarding = true;

  # Enable the KDE Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  security.pam.services.kwallet.enableKwallet = true;

  # Used by vscode, parcel and friends
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    gparted
    kwin
    pavucontrol
    yakuake
    konsole
    qt6.qtwayland
  ];

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Internationalization
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    # Use Italian for time and money
    extraLocaleSettings = {
      LC_TIME = "it_IT.UTF-8";
      LC_MONETARY = "it_IT.UTF-8";
    };
    supportedLocales = [
      "en_GB.UTF-8/UTF-8"
      "it_IT.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  # Fix themes not working for GTK apps in Wayland
  programs.dconf.enable = true;

  # Hardware
  hardware.keyboard.zsa.enable = true;
  services.blueman.enable = true;

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
    jack.enable = true;
  };
  users.groups.audio = { };

  programs.nix-ld.enable = true;

  # Users
  users.users.minibill.extraGroups = [
    "wheel"
    "networkmanager"
    "podman"
    "adbusers"
    "video"
    "plugdev"
    "libvirtd"
    "audio"
  ];
}
