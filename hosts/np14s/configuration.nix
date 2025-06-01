{
  inputs,
  lib,
  ...
}:

{
  imports = [
    ../common
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModule
    ../../modules
  ];

  my = {
    host = "np14s";
    modules = {
      btrfs-luks.enable = true;
      impermanence.enable = true;
    };
  };

  time.timeZone = "Europe/Berlin";

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "thunderbolt"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    initrd.kernelModules = [
      "dm-snapshot"
      "amdgpu"
    ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  services.libinput.enable = true;
}
