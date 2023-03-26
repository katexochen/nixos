# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix

    ../../modules/nix
    ../../modules/system
    ../../home/sway/greetd.nix
  ];

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
  boot.kernelModules = ["v4l2loopback"];
  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1
  '';

  programs.adb.enable = true;

  # Pick only one of the below networking options.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.hostName = "nt5"; # Define your hostname.
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
      symbolsFile = pkgs.copyPathToStore ../../symbols/us-custom;
    };
    de-custom = {
      description = "DE custom layout";
      languages = ["ger"];
      symbolsFile = pkgs.copyPathToStore ../../symbols/de-custom;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

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
      "adbusers"
    ];
  };

  home-manager = {
    # As suggested by https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  home-manager.users.katexochen = {pkgs, ...}: {
    imports = [
      ../../home
    ];

    home.stateVersion = "22.05";
    home.enableNixpkgsReleaseCheck = true;

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      XDG_CURRENT_DESKTOP = "sway";
      GOPRIVATE = "github.com/edgelesssys";
    };

    xdg.configFile."nixpkgs/config.nix".text = ''
      {
        allowUnfree = true;
      }
    '';
  };

  # Hardware Support for Wayland Sway
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  fonts.fontconfig = {
    enable = true;
    antialias = true;
    hinting = {
      enable = true;
      style = "hintfull"; # no difference
      autohint = true; # no difference
    };
    subpixel = {
      rgba = "rgb";
      lcdfilter = "default"; # no difference
    };
  };

  hardware.bluetooth = {
    enable = true;
  };

  services.dbus.enable = true;
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    };
  };

  # Needed to store VS Code auth tokens.
  services.gnome.gnome-keyring.enable = true;

  # Allow swaylock to unlock the computer for us
  security.pam.services.swaylock = {
    text = "auth include login";
  };
}
