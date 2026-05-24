{ pkgs, ... }:

{
  imports = [
    ./main.nix
    ./btrfs-luks.nix
    ./graphical.nix
  ];

  networking.networkmanager.enable = true;
  services.resolved.enable = true;

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

  environment.systemPackages = with pkgs; [
    mkpasswordfile
    nodeshell
    swaylock-cmd
    matrixc
  ];

  home-manager = {
    # As suggested by https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  home-manager.users.katexochen =
    { ... }:
    {
      imports = [ ../home ];

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
  boot.kernelPatches = [
    {
      name = "btmtk";
      patch = pkgs.fetchurl {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/patch/drivers/bluetooth/btmtk.c?id=e3ac0d9f1a205f33a43fba3b79ef74d2f604c78b";
        hash = "sha256-HjdGgDTGhxDBMX1blgtjo9Iq4udixqWGuSw8oD1zF6g=";
      };
    }
  ];

  # Needed to store VS Code auth tokens.
  services.gnome.gnome-keyring.enable = true;
}
