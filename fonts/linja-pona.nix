{ lib, fetchurl }:

let
  version = "4.9";
in
fetchurl {
  name = "linja-pona-${version}";

  url = "https://github.com/janSame/linja-pona/raw/8436d31ba84bb9c7198f7df2ec07d5b8b56ffdf7/linja-pona-${version}.otf";

  sha256 = "1s61lcmc958jxf55paw8wmi2mh5s3ihghr8x1q2ggb235x1b4xh5";

  downloadToTemp = true;
  recursiveHash = true;

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    cp -v $downloadedFile $out/share/fonts/opentype/linja-pona.otf
    chmod 444 $out/share/fonts/opentype/linja-pona.otf
  '';

  meta = with lib; {
    homepage = "https://github.com/janSame/linja-pona";
    description = "Linja Pona font for Toki Pona";
    longDescription = ''
      Linja Pona font for Toki Pona
    '';
    license = licenses.ofl;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
