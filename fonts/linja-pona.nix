{ lib, fetchurl }:

let
  version = "4.2";
in
fetchurl {
  name = "linja-pona-${version}";

  url = "https://github.com/janSame/linja-pona/raw/5c20b3f38b419a44e938ca8f2dff871c776c6579/linja-pona-${version}.otf";

  sha256 = "19596wh2yb4h5sp5lrd6bb2vqyaibj7dm9m7qm8gf1asw3kliaig";

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
