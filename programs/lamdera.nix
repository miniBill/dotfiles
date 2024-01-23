{ stdenv
, lib
, fetchurl
}:

let
  os = if stdenv.isDarwin then "macos" else "linux";
  arch = if stdenv.isAarch64 then "arm64" else "x86_64";
  hashes =
    {
      "x86_64-linux" = "B1x+wq+QP+7xZ/rO6f93RFo97ZfSOrUREW2Jq3y/rkY=";
      "aarch64-linux" = "afbc71f0570b86215942d1b4207fe3de0299e6fdfd2e6caac78bf688c81b9bd1";
      "x86_64-darwin" = "50a3df09b02b34e1653beb1507c6de0f332674e088ded7c66af4e5987753304e";
      "aarch64-darwin" = "+RwfJH1CkY5AdKsMTI70zCYLC+3WK4scgQ1lsLhexWQ=";
    };
in

stdenv.mkDerivation rec {
  pname = "lamdera";
  version = "next";

  src = fetchurl {
    url = "https://static.lamdera.com/bin/next/lamdera-${version}-${os}-${arch}";
    sha256 = hashes.${stdenv.system};
  };

  dontUnpack = true;

  installPhase = ''
    install -m755 -D $src $out/bin/lamdera
  '';

  meta = with lib; {
    homepage = "https://lamdera.com";
    license = licenses.unfree;
    description = "A delightful platform for full-stack web apps";
    platforms = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ Zimmi48 ];
  };
}
