{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.modules.impermanence;
in
{
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

    # From https://github.com/talyz/presentations/blob/master/impermanence-nixcon-2023/impermanence.org
    boot.initrd.postDeviceCommands = pkgs.lib.mkAfter ''
      echo "impermanence: Starting backup and cleanup procedure"
      mkdir /btrfs_tmp
      mount /dev/mapper/crypted /btrfs_tmp

      if [[ -e /btrfs_tmp/@ ]]; then
          mkdir -p /btrfs_tmp/old_@s
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/@ "/btrfs_tmp/old_@s/$timestamp"
          echo "impermanence: Old root subvolume moved to /btrfs_tmp/old_@s/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
          echo "impermanence: Deleted subvolume $1"
      }

      for i in $(find /btrfs_tmp/old_@s/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/@
      echo "impermanence: Created new root subvolume at /btrfs_tmp/@"

      umount /btrfs_tmp

      echo "impermanence: Done"
    '';
  };
}
