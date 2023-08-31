{ config
, pkgs
, ...
}:
let
  finalPkg = name: "${config.programs.${name}.finalPackage}";
  finalPkgBin = name: "${finalPkg name}/bin/${name}";
in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    systemd.enable = true;
    config = {
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${finalPkgBin "rofi"} -show drun -show-icons -pid";
      bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];

      modifier = "Mod4";
      down = "m";
      up = "u";
      left = "j";
      right = "k";

      input = {
        "type:keyboard" = {
          xkb_layout = "us-custom,de-custom";
          xkb_options = "ctrl:nocaps,grp:win_space_toggle";
        };
      };

      output = {
        "*".bg = "/home/katexochen/nixos/wallpaper/pastel.png fill";
      };

      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
          inherit
            (config.wayland.windowManager.sway.config)
            left
            down
            up
            right
            menu
            terminal
            ;
        in
        {
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+Shift+q" = "kill";
          "${mod}+d" = "exec ${menu}";

          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+r" = "restart";

          "${mod}+${left}" = "focus left";
          "${mod}+${down}" = "focus down";
          "${mod}+${up}" = "focus up";
          "${mod}+${right}" = "focus right";

          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${down}" = "move down";
          "${mod}+Shift+${up}" = "move up";
          "${mod}+Shift+${right}" = "move right";

          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";

          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";

          "${mod}+h" = "split h";
          "${mod}+v" = "split v";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+s" = "layout stacking";
          "${mod}+t" = "layout tabbed";
          "${mod}+e" = "layout toggle split";
          "${mod}+a" = "focus parent";
          "${mod}+Shift+a" = "focus child";

          "${mod}+equal" = "floating toggle";
          "${mod}+Shift+equal" = "focus mode_toggle";

          "${mod}+Shift+minus" = "move scratchpad";
          "${mod}+minus" = "scratchpad show";

          # Modes
          "${mod}+r" = "mode resize";
          "${mod}+Shift+v" = ''mode "system:  [r]eboot  [p]oweroff  [e]xit"'';

          # Shortcuts for applications
          "${mod}+c" = "exec ${finalPkgBin "rofi"} -show calc -modi calc -no-show-mathc -no-sort  -calc-command 'echo -n {result} | ${pkgs.wl-clipboard}/bin/wl-copy'";
          "${mod}+p" = "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g- screenshot-$(date +%Y%m%d-%H%M%S).png";
          "${mod}+Shift+p" = "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g- - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";
          "${mod}+i" = "exec ${pkgs.mako}/bin/makoctl dismiss";
          "${mod}+Shift+i" = "exec ${pkgs.mako}/bin/makoctl dismiss -a";
          "${mod}+l" = "exec ${pkgs.swaylock}/bin/swaylock";

          # XF86 keys
          "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t";
          "XF86AudioMicMute" = "exec ${pkgs.pamixer}/bin/pamixer --default-source -t";
          "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -i 5";
          "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -d 5";
          "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s +10%";
          "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s 10%-";
          "XF86Calculator" = "exec ${finalPkgBin "rofi"} -show calc -modi calc -no-show-mathc -no-sort";
        };

      modes = {
        "system:  [r]eboot  [p]oweroff  [e]xit" = {
          r = "exec systemctl reboot";
          p = "exec systemctl poweroff";
          e = "exit";
          Return = "mode default";
          Escape = "mode default";
        };
        resize = {
          Left = "resize shrink width";
          Right = "resize grow width";
          Down = "resize shrink height";
          Up = "resize grow height";
          Return = "mode default";
          Escape = "mode default";
        };
      };

      window.commands = [
        {
          criteria.app_id = ".*-floating";
          command = "floating enable";
        }
        {
          criteria.class = ".*";
          command = "inhibit_idle fullscreen";
        }
        {
          criteria.shell = "xwayland";
          command = "title_format \"%title :: %shell\"";
        }
        {
          criteria.app_id = "pavucontrol";
          command = "floating enable";
        }
        {
          criteria.app_id = "pavucontrol";
          command = "resize set 800 600";
        }
        {
          # Chromium inhibits sway shortcuts for some reason when using application
          # mode (--app=), this fixes that.
          # See: https://www.reddit.com/r/swaywm/comments/vkgfza
          criteria.app_id = "^chrome-.*-.*$";
          command = "shortcuts_inhibitor disable";
        }
      ];
    };
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export NIXOS_OZONE_WL=1
    '';
  };
}
