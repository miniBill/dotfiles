{ pkgs
, ...
}:

{
  imports = [ ../../groups/home-manager/graphical.nix ];

  home.packages = with pkgs; [
    agda
    gdu
    lld
    nh
    pkg-config
    rustup
  ];
}
