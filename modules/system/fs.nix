{ lib, config, ... }:
let
  cfg = config.my.modules.fs;
in
{
  options.my.modules = {
    fs = {
      enable = lib.mkEnableOption (lib.mkDoc "filesystem configuration");
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      initrd.luks.devices = {
        crypted = {
          device = "/dev/disk/by-label/crypted";
          preLVM = true;
        };
      };
    };

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = [ "noatime" ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    swapDevices = [
      { device = "/dev/disk/by-label/swap"; }
    ];
  };
}
