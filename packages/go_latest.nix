{ fetchurl
, go
}:
go.overrideAttrs
  (_: rec {
    version = "1.21.4";
    src = fetchurl {
      url = "https://go.dev/dl/go${version}.src.tar.gz";
      hash = "sha256-R7Jqg9K2WjwcG8rOJztpvuSaentRaKdgTe09JqN714c=";
    };
  })
