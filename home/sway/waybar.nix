{ pkgs, lib, ... }: {
  programs.waybar = {
    enable = true;
    systemd.target = "sway-session.target";
    style = ./waybar-style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [
          "sway/workspaces"
          "sway/window"
        ];
        modules-center = [
          "sway/mode"
        ];
        modules-right = [
          "tray"
          "pulseaudio"
          "bluetooth"
          "network#wifi"
          "network#speed"
          "battery"
          "cpu"
          "memory"
          "sway/language"
          "clock"
        ];

        "clock" = {
          tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%d.%m.%y}";
        };

        "cpu" = {
          interval = 2;
          format = "{usage}% ";
          tooltip = false;
          states = {
            warning = 70;
            critical = 90;
          };
        };

        "memory" = {
          interval = 2;
          format = "{}% ";
          tooltip-format = "{used:0.1f}G / {total:0.1f}G";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        "network#speed" = {
          interval = 2;
          tooltip-format = "{ifname} via {gwaddr} ";
          format = " {bandwidthDownBytes}  {bandwidthUpBytes}";
        };

        "network#wifi" = {
          interval = 10;
          format-wifi = "{essid} ({signalStrength}%) ";
          format = "";
          tooltip = false;
          on-click = "swaymsg exec \"${lib.getExe pkgs.alacritty} --class Alacritty-floating -e nmtui-connect\"";
        };

        "bluetooth" = {
          format = "";
          format-off = "";
          format-disabled = "";
          format-connected = " {num_connections}";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click-right = "bash -c \"if rfkill list bluetooth|grep -q 'yes$';then rfkill unblock bluetooth;else rfkill block bluetooth;fi\"";
          on-click = "swaymsg exec \"${lib.getExe pkgs.alacritty} --class Alacritty-floating -e ${lib.getExe pkgs.bluetuith}\"";
        };

        "pulseaudio" = {
          scroll-step = 5;
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            default = [ "" "" "" ];
          };
          "on-click" = "${lib.getExe pkgs.pavucontrol}";
        };

        "battery" = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = [ "" "" "" "" "" ];
        };

        "sway/window" = {
          format = "{}";
          max-length = 60;
          tooltip = false;
        };

        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
          tooltip = false;
        };

        "sway/language" = {
          on-click = "swaymsg input type:keyboard xkb_switch_layout next";
          tooltip = false;
        };
      };
    };
  };
}
