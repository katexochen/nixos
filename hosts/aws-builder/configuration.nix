{ config, pkgs, lib, inputs, ... }:
{
  users.users.katexochen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
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
    nixpkgs-fmt
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
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      max-jobs = 6;
      cores = 8;
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      timeout = 20;
    };
    initrd.availableKernelModules = [ "nvme" ];
    # TODO: correctly import ena module
    # extraModulePackages = [ boot.kernelPackages.ena ];
  };

  systemd.network.enable = true;
  networking.useDHCP = true;

  # debugging
  boot.kernelParams = [ "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1" ];
  services.getty.autologinUser = "root";

  disko.devices.disk.nvme0n1 = {
    device = "/dev/nvme0n1";
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
                mountOptions = [ "compress=zstd" ];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
            };
          };
        };
      };
    };
  };
}
