{ config, lib, pkgs, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 295;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
        }
        {
          timeout = 300;
          command = "${lib.getExe pkgs.swaylock-cmd}";
        }
        {
          timeout = 360;
          command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
          resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
        }
      ];
      events."before-sleep" = "${lib.getExe pkgs.swaylock-cmd}";
    };
  };
}
