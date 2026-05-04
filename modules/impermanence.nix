{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.my.modules.impermanence;
  luksName = config.my.modules.btrfs-luks.luksName;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.my.modules = {
    impermanence = {
      enable = lib.mkEnableOption (lib.mdDoc "impermanence");
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/etc/NetworkManager/system-connections"
        "/root/.local/share/nix/"
        "/root/.ssh"
        "/var/cache/tuigreet"
        "/var/lib/bluetooth"
        "/var/lib/NetworkManager"
        "/var/lib/nixos"
        "/var/lib/systemd/backlight"
        "/var/lib/tailscale"
      ];
      files = [
        "/etc/adjtime"
        "/etc/docker/key.json"
        "/etc/machine-id"
      ];
    };

    environment.systemPackages = [
      pkgs.impermanence-persist
    ];

    boot.initrd.systemd.services.impermanence-rollback = {
      description = "Wipe BTRFS root subvolume to a pristine state";
      wantedBy = [ "initrd.target" ];
      after = [ "systemd-cryptsetup@${luksName}.service" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        echo "impermanence: Starting backup and cleanup procedure" >&2
        mkdir -p /btrfs_tmp
        mount /dev/mapper/${luksName} /btrfs_tmp

        delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
          echo "impermanence: Deleted subvolume $1" >&2
        }

        if [[ -e /btrfs_tmp/@ ]]; then
            delete_subvolume_recursively /btrfs_tmp/@
        fi

        btrfs subvolume create /btrfs_tmp/@
        echo "impermanence: Created new root subvolume at /btrfs_tmp/@" >&2

        umount /btrfs_tmp
        echo "impermanence: Done" >&2
      '';
    };
  };
}
