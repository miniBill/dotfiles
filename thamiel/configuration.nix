{ ... }: {
  imports = [
    ./hardware-configuration.nix

    ../groups/common.nix
    ../groups/server.nix
  ];

  networking.hostName = "thamiel";

  zramSwap.enable = true;
  services.logind.extraConfig = "RuntimeDirectorySize=500M";

  users.mutableUsers = false;
  users.users = {
    minibill = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPassword = "$6$dPi0t.m3Rat601ku$zULH0TmfZQPZzxnQEchMGKLEUxnEFYkT47zWnNTfm3yopOEo5CdD6Ymhr1yIakq5zwtIaXDCAoaJWNYm5My0W0";
    };
    root = {
      hashedPassword = "$6$fWJ47Jp5U7LytfoV$Z1XqNGZIA0m9MUtNgmmjIGqsKkyoqT0PhQ0F7OyMrElwtjHeRrDUu5PzISxuUXgcxIauyA/8R/IH7r7cWq4Fu/";
      openssh.authorizedKeys.keys = [
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGAVCUqG9wVONKAUB449Zn+B/6nbKPFOlCcyCC55u3K minibill@uriel''
      ];
    };
  };

  system.stateVersion = "23.05";
}
