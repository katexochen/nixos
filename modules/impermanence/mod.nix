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

    boot.initrd.postDeviceCommands = pkgs.lib.mkAfter ''
      echo "impermanence: Starting backup and cleanup procedure" >&2
      mkdir /btrfs_tmp
      mount /dev/mapper/crypted /btrfs_tmp

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
}
