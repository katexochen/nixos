# Notes on setting up disk encryption

BASED ON: [this gist](https://gist.github.com/walkermalling/23cf138432aee9d36cf59ff5b63a2a58).

WARNING: You can run into a hidden problem that will prevent a correct partition setup and `/etc/nixos/configuration.nix` from working: if you are setting up a UEFI system, then you need to make sure you boot into the NixOS installation from the UEFI partition of the bootable media. You may have to enter your BIOS boot selection menu to verify this. For example, if you setup a NixOS installer image on a flash drive, your BIOS menu may display several boot options from that flash drive: choose the one explicitly labeled with "UEFI".

## Prep Disk

Start by taking a look at block devices and identify the name of the device you're setting up.

```sh
lsblk -o name,fstype,mountpoint,label,size,uuid
```

Wipe existing fs. on my machine the primary disk is /dev/sda, but it may be different on different machines. Note that Cryptsetup FAQ suggests we use `cat /dev/zero > [device target]`

```sh
wipefs -a /dev/sda
```

## Partition

Create a new partition table

```sh
parted /dev/sda -- mklabel gpt
```

Create the boot partition at the beginning of the disk

```sh
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- set 1 boot on
```

Create primary partition

```sh
parted /dev/sda -- mkpart primary 512MiB 100%
```

Now `/dev/sda1` is our boot partition, and `/dev/sda2` is our primary.

## Encrypt Primary Disk

Setup luks on sda2. This will prompt for creating a password.

```sh
cryptsetup luksFormat /dev/sda2
cryptsetup config /dev/sda2 --label crypted
cryptsetup luksOpen /dev/sda2 crypted
```

Map the physical, encrypted volume, then create a new volume group and logical volumes in that group for our nixos root and our swap.

```sh
pvcreate /dev/mapper/crypted
vgcreate vg /dev/mapper/crypted
lvcreate -L 8G -n swap vg
lvcreate -l '100%FREE' -n nixos vg
```

## Format Disks

The boot volume will be fat32. The filesystem will be ext4. Also creating a swap.

```sh
mkfs.fat -F 32 -n boot /dev/sda1
mkfs.ext4 -L nixos /dev/vg/nixos
mkswap -L swap /dev/vg/swap
```


## Mount

Mount the target file system to /mnt

```sh
mount /dev/disk/by-label/nixos /mnt
```

Mount the boot file system on /mnt/boot for UEFI boot

```sh
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

Activate swap

```sh
swapon /dev/vg/swap
```

## Resulting Disk

Expect the following result:

```txt
NAME           MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
loop0            7:0    0   1.1G  1 loop  /nix/.ro-store
sda              8:0    0 232.9G  0 disk
├─sda1           8:1    0   511M  0 part  /mnt/boot
└─sda2           8:2    0 232.4G  0 part
  └─crypted    254:0    0 232.4G  0 crypt
    ├─vg-swap  254:1    0     8G  0 lvm   [SWAP]
    └─vg-nixos 254:2    0 224.4G  0 lvm   /mnt
```


## Configure boot

generate configuration

```sh
nixos-generate-config --root /mnt
```


Edit configuration. Here is the part pertinent to luks setup:

```nix
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-label/crypted";
      preLVM = true;
    };
  };

  system.stateVersion = "22.05";
}
```

Note that the name of the encrypted filesystem in `boot.initrd.luks.devices` is the name used in `cryptsetup luksOpen` and in `vgcreate`.

## Install NixOs

Run the install

```sh
nixos-install
```

If install is successful, you'll be prompted to set password for root user. Then =reboot=, and remove installation media.

Login to root, and add add user:

```sh
useradd -c 'Me' -m me
passwd me
```

## Switch to existing config

Clone your repo

```sh
nix-shell -p git
git clone https://github.com/katexochen/nixos.git
```

Check the references in the hardware configuration are valid.

Then switch with

```sh
sudo nixos-rebuild switch  -I nixos-config=/home/katexochen/nixos/configuration.nix
```
