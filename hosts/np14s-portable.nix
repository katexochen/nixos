{
  lib,
  ...
}:

{
  my = {
    host = "np14s-portable";
    role = "client";
    modules = {
      btrfs-luks = {
        enable = true;
        disk = "/dev/sda";
        luksName = "crypted-portable";
      };
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
      "uas"
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
  services.resolved.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  services.btrbk.instances."ext-usb" = {
    onCalendar = null;
    settings = {
      incremental = "yes";
      stream_compress = "zstd";
      snapshot_create = "ondemand";
      snapshot_preserve_min = "20w";
      snapshot_preserve = "12m";
      target_preserve_min = "12w";
      target_preserve = "12m";
      subvolume."/mnt/work" = {
        snapshot_dir = "/mnt/work/.btrbk";
        target."/mnt/backup/work" = { };
      };
      subvolume."/mnt/private" = {
        snapshot_dir = "/mnt/private/.btrbk";
        target."/mnt/backup/private" = { };
      };
    };
  };

  services.libinput.enable = true;

  system.stateVersion = "25.11";
}
