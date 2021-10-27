{ pkgs ? import <nixpkgs> { }
, stdenv ? pkgs.stdenv
}:

stdenv.mkDerivation rec {
  name = "headsetcontrol";
  version = "2.5";

  src = builtins.fetchGit {
    url = "https://github.com/Sapd/HeadsetControl.git";
    ref = "fa2da0b2d1987547fb32c97942b2fea8a924253c";
  };

  nativeBuildInputs = with pkgs; [ cmake gcc ];
  buildInputs = with pkgs; [
    hidapi
  ];

  configurePhase = ''
    mkdir build && cd build
    cmake ..
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/udev/rules.d/
    chmod +x headsetcontrol
    cp headsetcontrol $out/bin
    ./headsetcontrol -u > $out/lib/udev/rules.d/70-headset-control.rules
  '';

  meta = {
    description = "headsetcontrol";
  };
}
