{
  inputs,
  lib,
  ...
}:

{
  imports = [
    ../common
    inputs.home-manager.nixosModules.home-manager
    ../../modules
  ];

  my = {
    host = "np14s";
    role = "client";
    modules = {
      btrfs-luks.enable = true;
      impermanence.enable = true;
      use-remote-builders.enable = true;
    };
  };

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

  system.stateVersion = "22.05";
}
