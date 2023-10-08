{ pkgs, ... }:
let
  mkpasswordfile = pkgs.writeShellApplication {
    name = "mkpasswordfile";
    text = ''mkpasswd -m sha-512 | sudo tee "$1" > /dev/null'';
  };
in
{
  imports = [
    ./nix
    ./services
    ./system
    ./impermanence
    ./btrfs-luks.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  programs.adb.enable = true;

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.extraHosts = ''
    127.0.0.1    license.confidential.cloud
  '';

  virtualisation.docker.enable = true;

  users = {
    mutableUsers = false;
    users.root.hashedPasswordFile = "/persist/secrets/root";
    users.katexochen = {
      hashedPasswordFile = "/persist/secrets/katexochen";
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
  };

  environment.systemPackages = [
    mkpasswordfile
  ];

  home-manager = {
    # As suggested by https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  home-manager.users.katexochen = { ... }: {
    imports = [
      ../home
    ];

    home.stateVersion = "22.05";
    home.enableNixpkgsReleaseCheck = true;

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      XDG_CURRENT_DESKTOP = "sway";
      GOPRIVATE = "github.com/edgelesssys";
    };

    fonts.fontconfig.enable = true;

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
      autohint = true; # no difference
    };
    subpixel = {
      rgba = "rgb";
      lcdfilter = "default"; # no difference
    };
  };

  hardware.bluetooth.enable = true;

  services.dbus.enable = true;
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };

  # Needed to store VS Code auth tokens.
  services.gnome.gnome-keyring.enable = true;

  # Allow swaylock to unlock the computer for us
  security.pam.services.swaylock = {
    text = "auth include login";
  };

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
