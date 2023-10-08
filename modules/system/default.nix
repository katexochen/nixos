{ lib, ... }: {
  imports = [
    ./fs.nix
  ];

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
