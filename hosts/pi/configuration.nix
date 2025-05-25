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
  ];

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      terminal = "screen-256color";
      historyLimit = 10000;
    };
    starship.enable = true;
  };

  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings = {
      dns = {
        upstream_dns = [
          # quad9
          "9.9.9.9"
          "149.112.112.112"
          "2620:fe::11"
          "2620:fe::fe:11"
          # google
          "8.8.8.8"
          "8.8.4.4"
          "2001:4860:4860::8888"
          "2001:4860:4860::8844"
          # cloudflare
          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::64"
          "2606:4700:4700::6400"
        ];
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;
          parental_enabled = false;
          safe_search.enabled = false;
        };
      };
      filters =
        map
          (url: {
            enabled = true;
            url = url;
          })
          [
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt" # AdGuard DNS filter
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt" # AdGuard DNS Popup Hosts filter
          ];
    };
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
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
  };

  networking = {
    hostName = "pi";
    useDHCP = true;
    firewall = {
      enable = true;
      allowedUDPPorts = [ 53 ];
    };
  };

  services.getty.autologinUser = "root";

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };
  swapDevices = [ ];

  security.sudo.wheelNeedsPassword = false;

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.11";
}
