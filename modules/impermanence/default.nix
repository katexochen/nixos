{ config, lib, pkgs, ... }:

let
  cfg = config.my.modules.impermanence;

  fs-diff = pkgs.writeShellApplication {
    name = "fs-diff";
    text = builtins.readFile ./fs-diff.sh;
  };

  persist = pkgs.writeShellApplication {
    name = "persist";
    text = builtins.readFile ./persist.sh;
  };
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
        "/etc/passwd"
        "/etc/shadow"
        "/etc/group"
        "/var/lib/bluetooth"
        "/var/lib/systemd/backlight"
      ];
      files = [
        "/etc/adjtime"
        "/etc/docker/key.json"
        "/etc/machine-id"
        "/var/lib/NetworkManager/NetworkManager.state"
        "/var/lib/NetworkManager/secret_key"
        "/var/lib/NetworkManager/seen-bssids"
        "/var/lib/NetworkManager/timestamps"
      ];
    };

    # Note `lib.mkBefore` is used instead of `lib.mkAfter` here.
    boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
      mkdir -p /mnt

      # We first mount the btrfs root to /mnt
      # so we can manipulate btrfs subvolumes.
      mount -o subvol=/ /dev/mapper/crypted /mnt

      # While we're tempted to just delete /root and create
      # a new snapshot from /root-blank, /root is already
      # populated at this point with a number of subvolumes,
      # which makes `btrfs subvolume delete` fail.
      # So, we remove them first.
      #
      # /root contains subvolumes:
      # - /root/var/lib/portables
      # - /root/var/lib/machines
      #
      # I suspect these are related to systemd-nspawn, but
      # since I don't use it I'm not 100% sure.
      # Anyhow, deleting these subvolumes hasn't resulted
      # in any issues so far, except for fairly
      # benign-looking errors from systemd-tmpfiles.
      btrfs subvolume list -o /mnt/root |
      cut -f9 -d' ' |
      while read subvolume; do
        echo "deleting /$subvolume subvolume..."
        btrfs subvolume delete "/mnt/$subvolume"
      done &&
      echo "deleting /root subvolume..." &&
      btrfs subvolume delete /mnt/root

      echo "restoring blank /root subvolume..."
      btrfs subvolume snapshot /mnt/root-blank /mnt/root

      # Once we're done rolling back to a blank snapshot,
      # we can unmount /mnt and continue on the boot process.
      umount /mnt
    '';

    environment.systemPackages = [
      fs-diff
      persist
    ];
  };
}
