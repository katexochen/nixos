{ config, ... }:

{

  imports = [ ../common ];

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

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      terminal = "screen-256color";
      historyLimit = 10000;
    };
  };

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
            url = url;
          })
          [
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt" # AdGuard DNS filter
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_24.txt" # 1Hosts (Lite)
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_27.txt" # OISD Blocklist Big
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt" # Steven Black's List
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_3.txt" # Peter Lowe's Blocklist
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_48.txt" # HaGeZi's Pro Blocklist
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_4.txt" # Dan Pollock's List
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_53.txt" # AWAvenue Ads Rule
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt" # AdGuard DNS Popup Hosts filter
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_39.txt" # Dandelion Sprout's Anti Push Notifications
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_47.txt" # HaGeZi's Gambling Blocklist
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_60.txt" # HaGeZi's Xiaomi Tracker Blocklist
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_61.txt" # HaGeZi's Samsung Tracker Blocklist
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_63.txt" # HaGeZi's Windows/Office Tracker Blocklist
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_6.txt" # Dandelion Sprout's Game Console Adblock List
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_7.txt" # Perflyst and Dandelion Sprout's Smart-TV Blocklist
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_10.txt" # Scam Blocklist by DurableNapkin
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # Malicious URL Blocklist (URLHaus)
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_12.txt" # Dandelion Sprout's Anti-Malware List
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_18.txt" # Phishing Army
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt" # Phishing URL Blocklist (PhishTank and OpenPhish)
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_42.txt" # ShadowWhisperer's Malware List
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_44.txt" # HaGeZi's Threat Intelligence Feeds
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt" # uBlock₀ filters – Badware risks
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_54.txt" # HaGeZi's DynDNS Blocklist
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_55.txt" # HaGeZi's Badware Hoster Blocklist
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_8.txt" # NoCoin Filter List
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
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
      allowedTCPPorts = [ config.services.adguardhome.settings.dns.port ];
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
