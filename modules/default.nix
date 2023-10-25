{ pkgs, ... }:
let
  mkpasswordfile = pkgs.writeShellApplication {
    name = "mkpasswordfile";
    text = ''mkpasswd -m sha-512 | sudo tee "$1" > /dev/null'';
  };

  mypkgs = import ../packages { inherit pkgs; };
in
{
  imports = [
    ./services
    ./system
    ./impermanence
    ./main.nix
    ./btrfs-luks.nix
    ./remote-builder.nix
    ./graphical.nix
  ];
  programs.adb.enable = true;

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.extraHosts = ''
    127.0.0.1    license.confidential.cloud
  '';

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
  ] ++ (with mypkgs; [
    nm-setup-rub-eduroam
  ]);

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

  hardware.bluetooth.enable = true;

  # Needed to store VS Code auth tokens.
  services.gnome.gnome-keyring.enable = true;
}
