{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi."3".leds;
  mkDisableOption =
    name:
    lib.mkOption {
      default = false;
      example = true;
      description = "Whether to disable ${name}.";
      type = lib.types.bool;
    };
in
{
  options.hardware.raspberry-pi."3".leds = {
    act.disable = mkDisableOption ''activity LED'';
    pwr.disable = mkDisableOption ''power LED'';
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.act.disable || cfg.pwr.disable) {
      hardware.deviceTree.enable = true;
      hardware.deviceTree.filter = "*-rpi-3-*.dtb";
    })
    (lib.mkIf cfg.act.disable {
      hardware.deviceTree = {
        overlays = [
          # Debugging:
          # $ hexdump /proc/device-tree/leds/led-act/gpios
          # $ cat /proc/device-tree/leds/led-act/linux,default-trigger
          {
            name = "disable-act-led";
            dtsText = ''
              /dts-v1/;
              /plugin/;
              / {
                compatible = "raspberrypi,3-model-b";
                fragment@0 {
                  target-path = "/leds/led-act";
                  __overlay__ {
                    default-state = "off";
                    linux,default-trigger = "none";
                  };
                };
              };
            '';
          }
        ];
      };
    })
    (lib.mkIf cfg.pwr.disable {
      hardware.deviceTree = {
        overlays = [
          # Checking the active device tree:
          # $ dtc -I fs /proc/device-tree -O dts  2>/dev/null | grep led-pwr -A7
          # Checking the path:
          # $ cat /proc/device-tree/__symbols__/led_pwr
          # Checking the state:
          # $ cat /proc/device-tree/leds/led-pwr/default-state
          # $ cat /proc/device-tree/leds/led-pwr/linux,default-trigger
          # Checking if the overlay is applied:
          # nixos-rebuild build <target>
          # nix log $(realpath result/dtbs)
          {
            name = "disable-pwr-led";
            dtsText = ''
              /dts-v1/;
              /plugin/;
              / {
                compatible = "raspberrypi,3-model-b";
                fragment@0 {
                  target-path = "/leds/led-pwr";
                  __overlay__ {
                    default-state = "off";
                    linux,default-trigger = "none";
                  };
                };
              };
            '';
          }
        ];
      };
    })
  ];
}
