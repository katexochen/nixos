{ config
, lib
, inputs
, pkgs
, ...
}:
let
  cfg = config.my;
in
{
  options.my = {
    user = lib.mkOption {
      type = lib.types.str;
    };
    host = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    networking.hostName = cfg.host;

    nixpkgs.config.allowUnfree = true;
    nix = {
      registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
      nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 20d";
      };
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
      };
    };

    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      loader.systemd-boot = {
        enable = true;
        configurationLimit = 30;
      };
      loader.efi.canTouchEfiVariables = true;
      tmp.cleanOnBoot = true;
    };

    zramSwap.enable = true;

    services = {
      earlyoom.enable = true;
      fwupd.enable = true;
      dbus.enable = true;
    };

    virtualisation.docker.enable = true;

    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    system.stateVersion = "22.05";
  };
}
