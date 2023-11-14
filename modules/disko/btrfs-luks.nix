{ lib
, disk
, ...
}:
let
  btrfMountOpts = [ "compress=zstd" "noatime" ];
in
{
  disko.devices = {
    disk = lib.genAttrs [ disk ] (device: {
      name = lib.replaceStrings [ "/" ] [ "-" ] device;
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "defaults" ];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              extraOpenArgs = [ "--allow-discards" ];
              askPassword = true;
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = btrfMountOpts;
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = btrfMountOpts;
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = btrfMountOpts;
                  };
                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = btrfMountOpts;
                  };
                  "@varlog" = {
                    mountpoint = "/var/log";
                    mountOptions = btrfMountOpts;
                  };
                };
              };
            };
          };
        };
      };
    });
  };
}
