{ ... }: {
  imports = [
    ./hardware-configuration.nix

    ../groups/common.nix
    ../groups/server.nix
  ];

  networking.hostName = "thamiel";

  zramSwap.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGAVCUqG9wVONKAUB449Zn+B/6nbKPFOlCcyCC55u3K minibill@uriel''
  ];

  system.stateVersion = "23.05";
}
