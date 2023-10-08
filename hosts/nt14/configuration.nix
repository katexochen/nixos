{ config
, inputs
, lib
, pkgs
, ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModule
    ../../modules
  ];

  my = {
    user = "katexochen";
    host = "nt14";
    modules = {
      btrfs-luks.enable = true;
      impermanence.enable = true;
    };
  };

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ "dm-snapshot" ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  services.xserver.libinput.enable = true;
}
