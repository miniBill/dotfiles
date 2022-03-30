{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      etcher
      (callPackage ../programs/lamdera.nix { })
    ];
  };
}
