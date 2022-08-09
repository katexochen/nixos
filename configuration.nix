# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

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

  # Enable the GNOME Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us-custom,de-custom";
  services.xserver.xkbOptions = "ctrl:nocaps,grp:win_space_toggle";

  # Custom keyboard layout
  # 
  # See:
  # https://nixos.org/manual/nixos/stable/#custom-xkb-layouts
  # https://discourse.nixos.org/t/5269
  # 
  # Might need to run 'gsettings reset org.gnome.desktop.input-sources sources' and logout/login.
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

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

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

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      # XDG_CURRENT_DESKTOP = "sway";
    };

    home.packages = with pkgs; [
      discord
      go_1_18
      firefox-wayland
      nixpkgs-fmt
    ];

    programs.git = {
      enable = true;
      userName = "katexochen";
      userEmail = "49727155+katexochen@users.noreply.github.com";
      aliases = { };
      difftastic.enable = true;
      includes = [{
        contents = {
          init.defaultBranch = "main";
        };
      }];
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

  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    htop
  ];

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

