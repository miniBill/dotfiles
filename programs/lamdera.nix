{ stdenv
, lib
, pkgs
, fetchurl
, ncurses5
, gmp5
, zlib
, autoPatchelfHook
}:

let
  isDarwin = stdenv.isDarwin;
  os = if isDarwin then "macos" else "linux";
  arch = if stdenv.isAarch64 then "arm64" else "x86_64";
  hashes =
    {
      "x86_64-linux" = "08h5xq6l2zdivgbyxfiivdpyifz684s1kzhb29hajvrnhws7cfj4";
      "aarch64-linux" = "0vcq5r47w7lzjzzdaal839krw6bhanphf7lgiaaw1w2d14xyq6zi";
      "x86_64-darwin" = "0lqqz5nqb6s473ivj6wnjlydbly4kr51mgb4pz0xn3r47v8qhnnh";
      "aarch64-darwin" = "02dh8nzfk21ip9ar92zj6l0ryy05n1mcbl9da2xa97jv7bm9nvy6";
    };
in

stdenv.mkDerivation rec {
  name = "lamdera-${version}";

  version = "1.1.0";


  src = fetchurl {
    url = "https://static.lamdera.com/bin/lamdera-${version}-${os}-${arch}";
    sha256 = hashes.${stdenv.system};
  };

  unpackPhase = ":";

  nativeBuildInputs =
    if isDarwin then
      [ ]
    else
      [ autoPatchelfHook ];

  buildInputs =
    if isDarwin then [
      ncurses5
      zlib
    ] else [
      ncurses5
      gmp5
      zlib
    ];

  sourceRoot = ".";

  installPhase = ''
    install -m755 -D $src $out/bin/lamdera
  '';

  meta = with lib; {
    homepage = "https://lamdera.com/";
    license = licenses.unfree;
    description = "Lamdera";
    platforms = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
  };
}
