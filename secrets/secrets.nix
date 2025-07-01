let
  # minibill = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGAVCUqG9wVONKAUB449Zn+B/6nbKPFOlCcyCC55u3K minibill@uriel";
  # users = [ minibill ];

  edge = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMT/em7DhFIVRdXQ+zRWneD5t3T9pk3OXFVQ7NAP+bjB root@edge";
  ithaca = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID+WUwSkJFEgHsHazSafR5czJiZN62oCm/ox8X2ViQ47 root@ithaca";
  milky = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICDSS99OTEcGWMtfdX+XU3JotWiBKtDpTwJ16FzZOVeZ root@milky";
  nathanda = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL7Zqky4160wkC79OABmxQkwUPli5+8zXIUw/dd5VseU root@nathanda";
  sohu = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILG+7Xahq/EMv+L+weICiUNgnU5cxb9owEhyoGG8nVaZ root@sohu";
  thamiel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPQGYonsRdGY68K4KiawiCOn/lWGGqUX8iLHvfRKtML1 root@thamiel";
  tharmas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF8UP9vkY+7OROsHeqZCnBlOwwPZW5fdoyENlxfpIGPl root@tharmas";
  uriel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMRil53Dkrw2+/QwfK/amfnPKGa6ZRmXBYrs3KB+aSY root@uriel";

  home = [
    edge
    nathanda
    sohu
    uriel
  ];
  servers = [
    ithaca
    milky
    thamiel
    tharmas
  ];
in
{
  "snizzovpn.age".publicKeys = home;

  "tailscale.age".publicKeys = home ++ servers;
  "cjdroute.conf.age".publicKeys = home ++ servers;
}
