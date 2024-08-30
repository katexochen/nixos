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
    diskonaut
    git
    starship
    go
    gotools
    nixpkgs-review
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
      # max-jobs = 6;
      # cores = 8;
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      timeout = 7;
    };
    initrd.kernelModules = [
      "nvme"
      "virtio_net"
      "virtio_pci"
      "virtio_mmio"
      "virtio_blk"
      "virtio_scsi"
      "9p"
      "9pnet_virtio"
    ];
    kernelModules = [
      "virtio_pci"
      "virtio_net"
      "virtio_balloon"
      "virtio_console"
      "virtio_rng"
      "virtio_gpu"
    ];
  };

  systemd.network.enable = true;
  networking.useDHCP = true;

  # debugging
  boot.kernelParams = [
    "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1"
    "console=/dev/tty0"
    "console=ttyS0"
    "console=tty1"
  ];

  services.getty.autologinUser = "root";
  services.udev.packages = [ pkgs.google-guest-configs ];
  services.udev.path = [ pkgs.google-guest-configs ];

  disko.devices.disk.sda = {
    device = "/dev/sda";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          type = "EF00";
          size = "500M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes = {
              "@" = {
                mountpoint = "/";
              };
              "@home" = {
                mountpoint = "/home";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };

  system.stateVersion = "24.10";
}
