{ ... }:

{
  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        "malia".id = "TFSZUCL-6NK3K6Q-V6VAWRB-IHFFTOE-SCDL3ZJ-DGF37N5-6MLVIUG-PX2BWAF";
        "nathanda".id = "JOM45EK-UVQ7OMB-EFCTKCN-5SMMNE7-YO22NCM-4PSQ3CK-QBLPVOW-EDVV4QK";
        "uriel".id = "QPKB44L-E7E7WID-TSB6EWI-6J7IUEX-BGRVH3A-ZVTXZ7B-WQZ2SJE-TGDAXAR";
      };

      folders = {
        "Global" = {
          devices = [
            "uriel"
            "malia"
            "nathanda"
          ];
          path = "~/Sync/Global";
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "31536000";
            };
          };
        };
        "Graphical" = {
          devices = [
            "uriel"
            "nathanda"
          ];
          path = "~/Sync/Graphical";
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "31536000";
            };
          };
        };
      };
    };
  };
}
