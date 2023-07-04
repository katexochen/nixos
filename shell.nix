{pkgs ? import <nixpkgs> {}}: let
  go_latest = pkgs.go.overrideAttrs (_: rec {
    version = "1.20.7";
    src = pkgs.fetchurl {
      url = "https://go.dev/dl/go${version}.src.tar.gz";
      hash = "sha256-LF7pyeweczsNu8K9/tP2IwblHYFyvzj09OVCsnUg9Zc=";
    };
  });
in
  pkgs.mkShell {
    nativeBuildInputs = [
      go_latest
    ];
  }
