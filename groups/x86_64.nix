{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      etcher
      spotify

      (callPackage ../programs/lamdera.nix { })
    ];
  };
}
