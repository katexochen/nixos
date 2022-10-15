{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    systemd.target = "sway-session.target";
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "custom/media"
        ];
        modules-center = [
          "sway/window"
        ];
        modules-right = [
          "tray"
          "pulseaudio"
          "network"
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

        "network" = {
          interval = 2;
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = " {bandwidthDownBytes}  {bandwidthUpBytes}";
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
            default = ["" "" ""];
          };
          # "on-click" = "pavucontrol";
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
    style = /home/katexochen/nixos/waybar-style.css;
  };
}