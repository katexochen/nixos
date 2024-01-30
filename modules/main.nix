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
        trusted-users = [ "root" "@wheel" ];
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

    console.useXkbConfig = true;
    zramSwap.enable = true;

    services = {
      earlyoom.enable = true;
      fwupd.enable = true;
      dbus.enable = true;
      xserver.xkb = {
        layout = "us-custom,de-custom";
        options = "ctrl:nocaps,grp:win_space_toggle";
        extraLayouts = {
          # Custom keyboard layout
          # https://nixos.org/manual/nixos/stable/#custom-xkb-layouts
          # https://discourse.nixos.org/t/5269
          # On change, run the following and logout:
          # gsettings reset org.gnome.desktop.input-sources xkb-options
          # gsettings reset org.gnome.desktop.input-sources sources
          us-custom = {
            description = "US custom layout";
            languages = [ "eng" ];
            symbolsFile = pkgs.copyPathToStore ../symbols/us-custom;
          };
          de-custom = {
            description = "DE custom layout";
            languages = [ "ger" ];
            symbolsFile = pkgs.copyPathToStore ../symbols/de-custom;
          };
        };
      };
    };

    virtualisation.docker.enable = true;

    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    time.timeZone = "Europe/Berlin";
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_TIME = "de_DE.UTF-8";
        LC_MEASUREMENTS = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_COLLATE = "C.UTF-8";
      };
    };

    system.activationScripts.diff = ''
      PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
      nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)
    '';
    # system.activationScripts.diff = ''
    #   if [[ -e /run/current-system ]]; then
    #     ${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig"
    #   fi
    # '';

    system.stateVersion = "22.05";
  };
}
