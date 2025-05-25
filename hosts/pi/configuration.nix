{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  users.users.katexochen = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };

  zramSwap.enable = true;

  environment.systemPackages = with pkgs; [
    btop
    gdu
    git
    go
    gotools
    nixpkgs-review
    starship
  ];

  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "screen-256color";
    historyLimit = 10000;
  };

  virtualisation.docker.enable = true;

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
  };

  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
      timeout = 7;
    };
    # kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    kernelModules = [ ];
  };

  networking.useDHCP = true;
  networking.hostName = "pi";

  services.getty.autologinUser = "root";

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };
  swapDevices = [ ];

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.11";
}
