let
  # minibill = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGAVCUqG9wVONKAUB449Zn+B/6nbKPFOlCcyCC55u3K minibill@uriel";
  # users = [ minibill ];

  uriel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMRil53Dkrw2+/QwfK/amfnPKGa6ZRmXBYrs3KB+aSY root@uriel";
  sohu = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILG+7Xahq/EMv+L+weICiUNgnU5cxb9owEhyoGG8nVaZ root@sohu";
  tharmas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF8UP9vkY+7OROsHeqZCnBlOwwPZW5fdoyENlxfpIGPl root@tharmas";
  home = [ uriel sohu ];
  servers = [ tharmas ];
in
{
  "snizzovpn.age".publicKeys = home;

  "tailscale.age".publicKeys = home ++ servers;
  "cjdroute.conf.age".publicKeys = home ++ servers;
}
