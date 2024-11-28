{ pkgs
, ...
}:

{
  imports = [ ../groups/graphical.nix ];

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
