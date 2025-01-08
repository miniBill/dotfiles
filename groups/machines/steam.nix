{ config, pkgs, lib, ... }:

{
  # 32-bit support for Steam
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  programs.steam.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
      "steam-runtime"
      "steam-unwrapped"
      "nvidia-settings"
      "nvidia-x11"
    ];
}
