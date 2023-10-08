{ config
, lib
, ...
}:
let
  cfg = config.my;
in
{
  options.my = {
    user = lib.mkOption {
      type = lib.types.str;
    };
    host = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    networking.hostName = cfg.host;
  };
}
