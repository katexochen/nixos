{ lib, ... }: {
  imports = [
    ./fs.nix
  ];

  my.modules.fs.enable = lib.mkDefault true;

  boot = {
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 30;
    };

    loader.efi.canTouchEfiVariables = true;
    tmp.cleanOnBoot = true;

    supportedFilesystems = [ "ntfs" ];
  };
}
