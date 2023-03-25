let
  # minibill = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGAVCUqG9wVONKAUB449Zn+B/6nbKPFOlCcyCC55u3K minibill@uriel";
  # users = [ minibill ];

  uriel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMRil53Dkrw2+/QwfK/amfnPKGa6ZRmXBYrs3KB+aSY root@uriel";
  systems = [ uriel ];
in
{
  "tailscale.age".publicKeys = systems;
  "snizzovpn.age".publicKeys = systems;
}
