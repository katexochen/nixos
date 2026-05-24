{ config, lib, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
