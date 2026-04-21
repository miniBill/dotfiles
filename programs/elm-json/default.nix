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
    rev = "4845078694f5dd8932d54db1406c80ec5d553ccb";
    hash = "sha256-pSt4ugP8r7s0ABT3Y9ZbWAG/ShsARtame2lTxXiCuws=";
  };

  cargoPatches = [ ./use-system-ssl.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    openssl
  ];

  cargoHash = "sha256-BnL//AHaSnsugtMEnSTynpMyeNt5N7L6PG2wdWDw1y4=";

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
