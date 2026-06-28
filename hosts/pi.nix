{ config, pkgs, ... }:

{
  my = {
    host = "pi";
    role = "server";
  };

  users.users.katexochen = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };

  zramSwap.enable = true;
  services.earlyoom.enable = true;

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      terminal = "screen-256color";
      historyLimit = 10000;
    };
  };

  services.speedtest-tracker = {
    enable = true;
    enableNginx = true;
    settings = {
      APP_KEY_FILE = toString (
        pkgs.writeText "app-key" "base64:QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUE="
      );
      SPEEDTEST_SCHEDULE = "7 * * * *";
    };
  };

  services.resolved.enable = false;
  services.tailscale.enable = false;
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
    port = 3000;
    settings = {
      schema_version = 29;
      clients.runtime_sources = {
        whois = true;
        arp = true;
        rdns = true;
        dhcp = true;
        hosts = false;
      };
      dns = {
        port = 53;
        bind_hosts = [ "0.0.0.0" ];
        bootstrap_dns = [
          "9.9.9.9"
          "2620:fe::11"
          "8.8.8.8"
          "2001:4860:4860::8888"
          "1.1.1.1"
          "2606:4700:4700::64"
        ];
        local_ptr_upstreams = [ "192.168.178.1" ];
        use_private_ptr_resolvers = true;
        private_networks = [
          "192.168.178.0/24"
          "fd64:6093:c007:1111::/64"
        ];
        upstream_dns = [
          "9.9.9.9"
          "149.112.112.112"
          "2620:fe::11"
          "2620:fe::fe:11"
          "https://dns10.quad9.net/dns-query"
          "8.8.8.8"
          "8.8.4.4"
          "2001:4860:4860::8888"
          "2001:4860:4860::8844"
          "https://dns.google/dns-query"
          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::64"
          "2606:4700:4700::6400"
          "https://dns.cloudflare.com/dns-query"
        ];
        upstream_mode = "fastest_addr";
        upstream_timeout = "1s";
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;
          parental_enabled = false;
          safesearch_enabled = false;
          safebrowsing_enabled = false;
        };
        cache_optimistic = true;
      };
      filters =
        map
          (url: {
            enabled = true;
            inherit url;
          })
          [
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_24.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_27.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_3.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_48.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_4.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_53.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_39.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_47.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_60.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_61.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_63.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_6.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_7.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_10.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_12.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_18.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_42.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_44.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_54.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_55.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_8.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
          ];
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
    useDHCP = true;
    firewall = {
      enable = true;
      allowedUDPPorts = [ config.services.adguardhome.settings.dns.port ];
      allowedTCPPorts = [
        config.services.adguardhome.settings.dns.port
        80
      ];
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
  hardware.raspberry-pi."3".leds = {
    act.disable = true;
    pwr.disable = true;
    eth.disable = true;
  };
  system.stateVersion = "25.11";
}
