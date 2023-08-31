{ pkgs
, config
, ...
}: {
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 295;
        command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
      }
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock";
      }
      {
        timeout = 360;
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock";
      }
    ];
  };
}
