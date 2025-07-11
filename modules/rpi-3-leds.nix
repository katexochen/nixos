{
  config,
  lib,
  pkgs,
  ...
}:

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
    eth.disable = mkDisableOption ''ethernet LEDs'';
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
    (lib.mkIf cfg.eth.disable {
      # Note: RPi 3B has ethernet over USB (LAN9514), so the ethernet device isn't
      # exposed via device tree and therefore eth leds cannot be disabled via such.
      # Instead, we can use the lan951x-led-ctl utility to control the LEDs.
      # The later RPi models (3B+ and 4) have the ethernet controller integrated
      # into the SoC and can disable the LEDs via device tree.
      systemd.services.disable-rpi-eth-leds = {
        description = "Disable Raspberry Pi 3B Ethernet LEDs using lan951x-led-ctl";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${lib.getExe pkgs.lan951x-led-ctl} --fdx=0 --lnk=0 --spd=0";
        };
      };
    })
  ];
}
