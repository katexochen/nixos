{ config, lib, pkgs, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.programs.rofi = {
      enable = true;
      plugins = with pkgs; [ rofi-calc ];
    };
  };
}
