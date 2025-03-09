{
  pkgs,
  ...
}:

{
  imports = [ ../../groups/home-manager/graphical.nix ];

  home.packages = with pkgs; [
    nh
    lld
    rustup
    pkg-config
  ];
}
