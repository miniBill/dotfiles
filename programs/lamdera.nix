{ stdenv
, lib
, fetchurl
, ncurses5
, gmp5
, zlib
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  name = "lamdera-${version}";

  version = "1.0.1";

  src = fetchurl {
    url = "https://static.lamdera.com/bin/linux/lamdera";
    sha256 = "sha256:1qxkfs65cxan6wfgfwcfs8h05sqys3f7km73lm8v36gk5niv4b7q";
    # url = "https://static.lamdera.com/bin/linux/lamdera-next";
    # sha256 = "sha256:15bm9ss18nzcdfy8ai3ywki268z81dvpx1ak0z9nc1cifnrw2ajh";
  };

  unpackPhase = ":";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    ncurses5
    gmp5
    zlib
  ];

  sourceRoot = ".";

  installPhase = ''
    install -m755 -D $src $out/bin/lamdera
  '';

  meta = with lib; {
    homepage = "https://lamdera.app/";
    license = licenses.unfree;
    description = "Lamdera";
    platforms = [ "x86_64-linux" ];
  };
}
