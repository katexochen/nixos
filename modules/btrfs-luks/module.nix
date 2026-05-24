{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.modules.btrfs-luks;
in
{
  options.my.modules.btrfs-luks = {
    enable = lib.mkEnableOption (lib.mkDoc "btrfs-luks");
    disk = lib.mkOption {
      type = lib.types.str;
      default = "/dev/nvme0n1";
      description = "Disk to install to";
    };
    luksName = lib.mkOption {
      type = lib.types.str;
      default = "crypted";
      description = "Name for the LUKS container";
    };
  };

  config = lib.mkIf cfg.enable {
    disko.devices =
      (pkgs.callPackage ./disko.nix {
        inherit lib;
        inherit (cfg) disk luksName;
      }).disko.devices;

    fileSystems."/persist".neededForBoot = true;
  };
}
