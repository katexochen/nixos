{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf (config.my.role == "client") {
    services.power-profiles-daemon.enable = true;
    environment.systemPackages = [ pkgs.toggle-power-profile ];

    systemd.services.power-profile-by-ac = {
      description = "Set power profile based on AC adapter state";
      after = [ "power-profiles-daemon.service" ];
      wants = [ "power-profiles-daemon.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        if [[ "$(cat /sys/class/power_supply/AC/online)" = "1" ]]; then
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance
        else
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
        fi
      '';
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", KERNEL=="AC", TAG+="systemd", ENV{SYSTEMD_WANTS}="power-profile-by-ac.service"
    '';
  };
}
