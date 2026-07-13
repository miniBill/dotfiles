{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  curl,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "elm-json";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "CharlonTank";
    repo = "elm-json";
    rev = "3c61cffe1d49593a65af2079945f6cc033f6bf18";
    hash = "sha256-IVfVDWacCXTaw/8mA+YH8vbfF1Os4/OlOlyYVjlD+Vw=";
  };

  cargoPatches = [ ./use-system-ssl.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    openssl
  ];

  cargoHash = "sha256-4Cw2LfmgAXUmJxf784Ot6w3/N7sWCK6w6YXpyJWAitg=";

  # Tests perform networking and therefore can't work in sandbox
  doCheck = false;

  meta = {
    description = "Install, upgrade and uninstall Elm dependencies";
    mainProgram = "elm-json";
    homepage = "https://github.com/zwilias/elm-json";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.turbomack ];
  };
})
