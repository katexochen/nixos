{ config, lib, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.services.mako = {
      enable = true;
      settings = {
        default-timeout = 4500;
        background-color = "#2e3440";
        ignore-timeout = true;
        "mode=do-not-disturb".invisible = true;
      };
    };
  };
}
