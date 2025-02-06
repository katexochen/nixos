{ pkgs, ... }:
let
  yamlToJson =
    drv:
    pkgs.stdenv.mkDerivation {
      name = "${drv.name}-json";
      src = drv;
      nativeBuildInputs = [ pkgs.yq-go ];
      buildCommand = ''cat $src | yq -o json > $out'';
    };

  fromYAML = str: builtins.fromJSON (builtins.readFile (yamlToJson str));
in

{
  programs.k9s = {
    enable = true;
    settings.k9s = {
      ui = {
        skin = "transparent";
        logoless = true;
      };
      skipLatestRevCheck = true;
      logger.textWrap = true;
    };
    skins.transparent = fromYAML (
      pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/derailed/k9s/v${pkgs.k9s.version}/skins/transparent.yaml";
        hash = "sha256-4+tCRcI5fsSwqqhnNEZiD6LAc6ZW/AaP7KZ0003/XSE=";
      }
    );
  };
}
