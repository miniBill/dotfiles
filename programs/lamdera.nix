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
    sha256 = "sha256:17wx4g8vna8dlgkv1qjzl1xkx36dgl7rvn7vcmxb0wafbpgykphm";
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
