{
  config,
  lib,
  ...
}:

let
  cfg = config.my;
in

{
  options.my = {
    host = lib.mkOption {
      type = lib.types.str;
    };
    role = lib.mkOption {
      type = lib.types.oneOf [
        (lib.types.enum [
          "server"
          "client"
        ])
      ];
    };
  };

  config = lib.mkIf (cfg != null) {
    networking.hostName = cfg.host;
  };
}
