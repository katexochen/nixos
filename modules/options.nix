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
    user = lib.mkOption {
      type = lib.types.str;
      default = "katexochen";
      description = "Primary user name.";
    };
    host = lib.mkOption {
      type = lib.types.str;
      description = "Hostname of the machine.";
    };
    role = lib.mkOption {
      type = lib.types.enum [
        "server"
        "client"
      ];
      description = "Role of the machine.";
    };
  };

  config = {
    networking.hostName = cfg.host;
  };
}
