{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot = lib.mkIf (config.my.role == "client") {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 30;
    };
    loader.efi.canTouchEfiVariables = true;
    tmp.cleanOnBoot = true;
  };

  console.useXkbConfig = lib.mkDefault true;
  zramSwap.enable = lib.mkDefault true;

  services = {
    earlyoom.enable = lib.mkDefault true;
    fwupd.enable = lib.mkIf (config.my.role == "client") true;
    dbus = {
      enable = true;
      implementation = "broker";
    };
  };

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  system.etc.overlay.enable = lib.mkIf (config.my.role == "client") true;

  system.activationScripts.diff = ''
    PATH=$PATH:${
      lib.makeBinPath [
        pkgs.nvd
        pkgs.nix
      ]
    }
    nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)
  '';
}
