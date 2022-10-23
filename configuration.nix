# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in {
  imports = [
    ./hardware-configuration.nix
    (import "${home-manager}/nixos")
    ./home/sway/greetd.nix
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
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-label/crypted";
      preLVM = true;
    };
  };

  # Use latest kernel
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Pick only one of the below networking options.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.hostName = "nixos"; # Define your hostname.
  networking.extraHosts = ''
    127.0.0.1    license.confidential.cloud
  '';

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "de_DE.UTF-8";
    LC_MEASUREMENTS = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
  };

  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    useXkbConfig = true; # use xkbOptions in tty.
  };

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
      languages = ["eng"];
      symbolsFile = /home/katexochen/nixos/symbols/us-custom;
    };
    de-custom = {
      description = "DE custom layout";
      languages = ["ger"];
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

  virtualisation.docker.enable = true;

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
      "docker" # Access to the docker socket.
    ];
  };

  home-manager = {
    # As suggested by https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  home-manager.users.katexochen = {pkgs, ...}: {
    imports = [
      ./home/chromium.nix
      ./home/git.nix
      ./home/vscode.nix
      ./home/teams.nix
      ./home/discord.nix
      ./home/spotify.nix
      ./home/sway/sway.nix
      ./home/sway/waybar.nix
      ./home/sway/mako.nix
    ];

    home.stateVersion = "22.05";
    home.enableNixpkgsReleaseCheck = true;

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      XDG_CURRENT_DESKTOP = "sway";
      GOPRIVATE = "github.com/edgelesssys";
    };

    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      mpv
      nixpkgs-fmt
      pavucontrol

      # Development
      cmake
      docker
      gcc
      gh
      gnumake
      go_1_18
      gopls
      gotools

      # Cloud
      awscli2
      azure-cli
      azure-storage-azcopy
      google-cloud-sdk
      k9s
      kubectl
      terraform

      # CLI
      bat
      curl
      exa
      fd
      file
      htop
      jq
      killall
      ripgrep
      unzip
      wget
      yq

      # Fonts
      font-awesome
      dejavu_fonts
      noto-fonts-emoji
      (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
      source-code-pro
      helvetica-neue-lt-std
      ubuntu_font_family

      # Sway
      swaylock
      swayidle
      xwayland
      xdg-utils
      kanshi
      grim
      slurp
      wl-clipboard
      wf-recorder
      pamixer
    ];

    programs.alacritty = {
      enable = true;
      settings = {
        selection.save_to_clipboard = true;
        window = {
          padding = {
            x = 20;
            y = 20;
          };
          opacity = 0.8;
        };
        font = {
          size = 12;
        };
      };
    };

    programs.bash = {
      enable = true;
      historyIgnore = [
        "cd"
        "exit"
        "ls"
        "shutdown"
      ];
      sessionVariables = {
        EDITOR = "nano";
      };
      initExtra = ''
        export PATH=$PATH:$(go env GOPATH)/bin
      '';
      shellAliases = {
        cat = "bat -pp";
        k = "kubectl";
        ls = "exa --git -L 3";
      };
    };

    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        golang = {
          symbol = "[  ](regular)";
        };
        aws.disabled = true;
        azure.disabled = true;
        gcloud.disabled = true;
      };
    };

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = with pkgs; [
        rofi-calc
      ];
    };
  };

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
      extraPortals = with pkgs; [xdg-desktop-portal-gtk];
      gtkUsePortal = true;
    };
  };

  # Needed to store VS Code auth tokens.
  services.gnome.gnome-keyring.enable = true;

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
