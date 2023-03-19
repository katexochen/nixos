{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  boot = {
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 30;
    };

    loader.efi.canTouchEfiVariables = true;

    initrd.luks.devices = {
      crypted = {
        device = "/dev/disk/by-label/crypted";
        preLVM = true;
      };
    };

    supportedFilesystems = ["ntfs"];

    # tmpOnTmpfs = true;
    # cleanTmpDir = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-label/swap";}
  ];
}
