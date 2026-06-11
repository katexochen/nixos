{ config, lib, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user} =
      { config, ... }:
      {
        services.mako = {
          enable = true;
          settings = {
            default-timeout = 4500;
            background-color = "#2e3440";
            ignore-timeout = true;
            "mode=do-not-disturb".invisible = true;
          };
        };

        # home-manager's `services.mako` only writes the config file and registers
        # D-Bus activation; it never defines a systemd service. That leaves mako
        # running unmanaged (no Restart=, not bound to the graphical session), so a
        # wedged instance is never recovered and notifications silently queue
        # without rendering. Define a managed service that starts with the session,
        # owns the notification bus from the start, and restarts on failure.
        systemd.user.services.mako = {
          Unit = {
            Description = "Lightweight Wayland notification daemon";
            Documentation = "man:mako(1)";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
            ConditionEnvironment = "WAYLAND_DISPLAY";
          };
          Service = {
            Type = "dbus";
            BusName = "org.freedesktop.Notifications";
            ExecStart = "${config.services.mako.package}/bin/mako";
            ExecReload = "${config.services.mako.package}/bin/makoctl reload";
            Restart = "on-failure";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      };
  };
}
