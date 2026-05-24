{ config, lib, pkgs, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.home.packages =
      (with pkgs; [
        mpv
        pavucontrol
        tailscale
        signal-desktop
        amp-cli
        slack
      ])
      ++ (with pkgs.webapps; [
        discord
        teams
        spotify
      ]);
  };
}
