{ inputs
, lib
, ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModule
    ../../modules
  ];

  my = {
    user = "katexochen";
    host = "np14s";
    modules = {
      btrfs-luks.enable = true;
      impermanence.enable = true;
    };
  };

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ "dm-snapshot" "amdgpu" ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  services.libinput.enable = true;
}
