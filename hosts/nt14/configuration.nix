# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ inputs
, lib
, pkgs
, ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModule
    ./hardware-configuration.nix
    ../../modules
  ];

  my.modules = {
    btrfs-luks.enable = true;
    impermanence.enable = true;
  };

  networking.hostName = "nt14";
  services.xserver.libinput.enable = true;
}
