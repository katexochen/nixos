{
  lib,
  pkgs,
  ...
}:

{
  config = {
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
      tailscale.enable = true;
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

    system.activationScripts.diff = ''
      PATH=$PATH:${
        lib.makeBinPath [
          pkgs.nvd
          pkgs.nix
        ]
      }
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
