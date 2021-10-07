{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  name = "wally-cli-2.0.0";
  src = pkgs.fetchurl {
    name = "wally-cli";
    url = "https://github.com/zsa/wally-cli/releases/download/2.0.0-linux/wally-cli";
    sha256 = "0048ndgk0r2ln0f4pcy05xfwp022q8p7sdwyrfjk57d8q4f773x3";
  };
  dontStrip = true;
  unpackPhase = ''
    cp $src ./wally-cli
  '';
  installPhase = ''
    mkdir -p $out/bin
    chmod +wx wally-cli
    cp wally-cli $out/bin
    ${pkgs.patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${pkgs.lib.makeLibraryPath [ pkgs.libusb1 ]}" \
      $out/bin/wally-cli
  '';
}
