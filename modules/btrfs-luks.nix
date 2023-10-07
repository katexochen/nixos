{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.my.modules.btrfs-luks;
in
{
  options.my.modules = {
    btrfs-luks = {
      enable = lib.mkEnableOption (lib.mkDoc "btrfs-luks");
      disk = lib.mkOption {
        type = lib.types.str;
        default = "/dev/nvme0n1";
        description = "Disk to install to";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    disko.devices = (pkgs.callPackage ./disko/btrfs-luks.nix {
      inherit lib;
      disk = cfg.disk;
    }).disko.devices;

    fileSystems."/persist".neededForBoot = true;
  };
}
