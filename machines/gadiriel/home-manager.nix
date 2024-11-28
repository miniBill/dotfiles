{ pkgs
, ...
}:

{
  imports = [ ../../groups/home-manager/graphical.nix ];

  home.packages = with pkgs; [
    nh
    # Rust
    lld
    cargo
    rust-analyzer
    rustc
    rustfmt
    pkg-config
  ];
}
