{ pkgs ? import <nixpkgs> { }
, stdenv ? pkgs.stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  name = "headsetcontrol";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "Sapd";
    repo = "HeadsetControl";
    rev = "6c224e70372843c4f316975ef6ed078f2eae593c";
    sha256 = "sha256-iD5yADhX5djBAntLxGQSyyyhNTAx00XcihLRSjXtsv4=";
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
