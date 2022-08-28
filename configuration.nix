# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
  imports =
    [
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/katexochen/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 30;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Pick only one of the below networking options.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.hostName = "nixos"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "de_DE.UTF-8";
    LC_MEASUREMENTS = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
  };

  # console = {
  #   font = "Lat2-Terminus16";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Configure keymap in X11
  services.xserver.layout = "us-custom,de-custom";
  services.xserver.xkbOptions = "ctrl:nocaps,grp:win_space_toggle";

  # Custom keyboard layout
  # 
  # See:
  # https://nixos.org/manual/nixos/stable/#custom-xkb-layouts
  # https://discourse.nixos.org/t/5269
  # 
  # On change, run the following and logout:
  # gsettings reset org.gnome.desktop.input-sources xkb-options
  # gsettings reset org.gnome.desktop.input-sources sources
  services.xserver.extraLayouts = {
    us-custom = {
      description = "US custom layout";
      languages = [ "eng" ];
      symbolsFile = /home/katexochen/nixos/symbols/us-custom;
    };
    de-custom = {
      description = "DE custom layout";
      languages = [ "ger" ];
      symbolsFile = /home/katexochen/nixos/symbols/de-custom;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.katexochen = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable 'sudo' for user.
      "video" # Access to webcam and other video devices.
      "audio" # Access to soundcard and micro.
      "networkmanager"
      "lp" # Enable use of printers.
      "scanner" # Enable use of scanners.
    ];
  };

  home-manager = {
    # As suggested by https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  home-manager.users.katexochen = { pkgs, ... }: {

    home.stateVersion = "22.05";
    home.enableNixpkgsReleaseCheck = true;

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      XDG_CURRENT_DESKTOP = "sway";
    };

    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      discord
      go_1_18
      nixpkgs-fmt

      # Fonts
      font-awesome
      dejavu_fonts
      fira
      fira-code
      fira-code-symbols
      source-code-pro
      helvetica-neue-lt-std
      ubuntu_font_family

      # Sway
      swaylock
      swayidle
      xwayland
      mako
      kanshi
      grim
      slurp
      wl-clipboard
      wf-recorder
      pamixer
    ];

    programs.git = {
      enable = true;
      userName = "katexochen";
      userEmail = "49727155+katexochen@users.noreply.github.com";
      aliases = {
        sl = "log --pretty=format:'%Cred%h  %Creset%<(40)%s %Cgreen%<(12)%cr %Cblue%an%Creset%C(yellow)%d%Creset' --abbrev-commit";
      };
      difftastic.enable = true;
      includes = [{
        contents = {
          init.defaultBranch = "main";
        };
      }];
    };

    programs.firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
      profiles = {
        katexochen = {
          id = 0;
          isDefault = true;
          settings = {
            "browser.aboutwelcome.enabled" = false;
            "browser.ctrlTab.sortByRecentlyUsed" = true;
            "browser.newtabpage.enabled" = false;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.startup.homepage" = "https://search.nixos.org/packages";
            "browser.startup.page" = 3;
            "browser.tabs.unloadOnLowMemory" = true;
            "browser.warnOnQuit" = false;

            # Privacy
            # https://github.com/arcnmx/home/blob/58a00746ecbcfb3eba4b157a7a22641486943c84/cfg/firefox/default.nix
            "app.shield.optoutstudies.enabled" = true;
            "beacon.enabled" = false;
            "breakpad.reportURL" = "";
            "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
            "browser.onboarding.enabled" = false;
            "browser.ping-centre.telemetry" = false;
            "browser.safebrowsing.blockedURIs.enabled" = false;
            "browser.safebrowsing.downloads.enabled" = false;
            "browser.safebrowsing.downloads.remote.enabled" = false;
            "browser.safebrowsing.downloads.remote.url" = "";
            "browser.safebrowsing.malware.enabled" = false;
            "browser.safebrowsing.phishing.enabled" = false;
            "browser.safebrowsing.updateURL" = "";
            "browser.search.update" = false;
            "browser.selfsupport.url" = "";
            "datareporting.policy.dataSubmissionEnabled" = false;
            "datareporting.sessions.current.clean" = true;
            "device.sensors.enabled" = false;
            "devtools.onboarding.telemetry.logged" = false;
            "devtools.webide.autoinstallADBHelper" = false;
            "devtools.webide.autoinstallFxdtAdapters" = false;
            "devtools.webide.enabled" = false;
            "dom.battery.enabled" = false;
            "dom.enable_performance" = false;
            "dom.ipc.plugins.reportCrashURL" = false;
            "experiments.enabled" = false;
            "extensions.getAddons.cache.enabled" = false;
            "extensions.pocket.enabled" = true;
            "geo.enabled" = false;
            "geo.wifi.uri" = false;
            "network.allow-experiments" = false;
            "network.captive-portal-service.enabled" = false;
            "privacy.trackingprotection.cryptomining.enabled" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.fingerprinting.enabled" = true;
            "privacy.trackingprotection.introCount" = 20;
            "security.family_safety.mode" = 0;
            "services.sync.prefs.sync.browser.safebrowsing.malware.enabled" = false;
            "services.sync.prefs.sync.browser.safebrowsing.phishing.enabled" = false;
            "services.sync.prefs.sync.privacy.donottrackheader.value" = false;
            "social.directories" = "";
            "social.remote-install.enabled" = false;
            "social.toast-notifications.enabled" = false;
            "social.whitelist" = "";
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.server" = "";
            "toolkit.telemetry.unified" = false;

            # concessions
            "network.dns.disablePrefetch" = false;
            "network.http.speculative-parallel-limit" = 8;
            "network.predictor.cleaned-up" = true;
            "network.predictor.enabled" = true;
            "network.prefetch-next" = true;
            "security.dialog_enable_delay" = 300;
          };
        };
      };
    };

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        # bbenoist.nix
        # brettm12345.nixfmt-vscode
        # davidanson.vscode-markdownlint
        # github.github-vscode-theme
        # github.vscode-pull-request-github
        eamodio.gitlens
        github.copilot
        golang.go
        james-yu.latex-workshop
        jnoortheen.nix-ide
        streetsidesoftware.code-spell-checker
        yzhang.markdown-all-in-one
      ];
      userSettings = { };
      keybindings = [ ];
    };

    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      systemdIntegration = true;
      config = {
        terminal = "${pkgs.alacritty}/bin/alacritty";
        menu = "${pkgs.rofi}/bin/rofi -show run -show-icons -pid";
        bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];
        modifier = "Mod4";
        input = {
          "type:keyboard" = {
            xkb_layout = "us-custom,de-custom";
            xkb_options = "ctrl:nocaps,grp:win_space_toggle";
          };
        };
        keybindings = lib.mkOptionDefault {
          "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t";
          "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -i 5";
          "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -d 5";
          "XF86Calculator" = "exec ${pkgs.rofi}/bin/rofi -show calc -modi calc -no-show-mathc -no-sort";
        };
        output = {
          "*".bg = "/home/katexochen/nixos/wallpaper/pastel.png fill";
        };
      };
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
        export NIXOS_OZONE_WL=1
      '';
    };

    programs.alacritty = {
      enable = true;
      settings = {
        selection.save_to_clipboard = true;
      };
    };

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = with pkgs; [
        rofi-calc
      ];
    };

    programs.waybar = {
      enable = true;
      systemd.target = "sway-session.target";
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;

          modules-left = [
            "sway/workspaces"
            "sway/mode"
            "custom/media"
          ];
          modules-center = [
            "sway/window"
          ];
          modules-right = [
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "sway/language"
            "clock"
            "tray"
          ];

          "clock" = {
            tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%d.%m.%y}";
          };

          "cpu" = {
            interval = 2;
            format = "{usage}% ";
            tooltip = false;
          };

          "memory" = {
            interval = 2;
            format = "{}% ";
          };

          "network" = {
            interval = 2;
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "{ipaddr}/{cidr} ";
            tooltip-format = "{ifname} via {gwaddr} ";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "Disconnected ⚠";
            format-alt = " {bandwidthDownBytes}  {bandwidthUpBytes}";
          };

          "pulseaudio" = {
            scroll-step = 5;
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              default = [ "" "" "" ];
            };
            # "on-click" = "pavucontrol";
          };

        };
      };
      style = /home/katexochen/nixos/waybar-style.css;
    };

  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    htop
  ];

  # Hardware Support for Wayland Sway
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  services.dbus.enable = true;
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      gtkUsePortal = true;
    };
  };

  # Allow swaylock to unlock the computer for us
  security.pam.services.swaylock = {
    text = "auth include login";
  };

  # Automatic updates
  system.autoUpgrade = {
    #   enable = true;
    channel = "https://nixos.org/channels/nixos-22.05";
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 20d";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

