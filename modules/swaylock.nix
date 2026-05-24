{ config, lib, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    security.pam.services = {
      swaylock.text = "auth include login";
      swaylock-plugin.text = "auth include login";
    };

    home-manager.users.${user}.programs.swaylock.settings = {
      image = "${../wallpaper/pastel.png}";
      daemonize = true;
      ignore-empty-password = true;
    };
  };
}
