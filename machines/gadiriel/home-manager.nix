{
  pkgs,
  ...
}:

{
  imports = [ ../../groups/home-manager/graphical.nix ];

  home.packages = with pkgs; [
    agda
    nh
    lld
    rustup
    pkg-config
  ];
}
