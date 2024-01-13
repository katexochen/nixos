{ pkgs, ... }:
let
  yamlToJson = drv: pkgs.stdenv.mkDerivation {
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
    skins.transparent = builtins.fromJSON (builtins.readFile ./k9s-skin-transparent.json);
    # Skin broken in 0.31.5
    # fromYAML (pkgs.fetchurl {
    #       url = "https://raw.githubusercontent.com/derailed/k9s/v${pkgs.k9s.version}/skins/transparent.yaml";
    #       hash = "sha256-QF5qKEHqbR+4oKmQQm1NQGKzx5dqoCuzVNG7c/qQy3Q=";
    #     })
  };
}
