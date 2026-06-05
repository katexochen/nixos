{
  config,
  lib,
  pkgs,
  ...
}:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    hardware.graphics.enable = true;
    hardware.bluetooth.enable = true;

    boot = {
      supportedFilesystems = [ "ntfs" ];
      kernelParams = [ "console=tty1" ];
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };

    security.pam.services = {
      greetd.enableGnomeKeyring = true;
      greetd-password.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
    };
    environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";

    services = {
      printing.enable = true;
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
      greetd = {
        enable = true;
        useTextGreeter = true;
        settings = {
          default_session = {
            command = lib.concatStringsSep " " [
              "${pkgs.tuigreet}/bin/tuigreet"
              "--remember"
              "--time"
              "--asterisks"
              "--cmd ${pkgs.sway}/bin/sway"
            ];
          };
        };
      };
      gnome.gnome-keyring.enable = true;
    };

    environment.systemPackages = with pkgs; [
      mkpasswordfile
      nodeshell
      swaylock-cmd
      matrixc
    ];

    home-manager.users.${user} = {
      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
        XDG_CURRENT_DESKTOP = "sway";
        GOPRIVATE = "github.com/edgelesssys";
      };
    };
  };
}
