#!/usr/bin/env bash
# fs-diff.sh

set -euo pipefail

cleanup=()

if [[ ! -e "/mnt" ]]; then
  sudo mkdir -p /mnt
  cleanup+=("sudo rm -d /mnt")
fi

if [[ ! $(findmnt /mnt) ]]; then
  sudo mount -o subvol=/ /dev/mapper/crypted /mnt
  cleanup+=("sudo umount /mnt")
fi

oldTransID=$(sudo btrfs subvolume find-new /mnt/root-blank 9999999)
oldTransID=${oldTransID#transid marker was }

sudo btrfs subvolume find-new "/mnt/root" "${oldTransID}" |
  sed '$d' |
  cut -f17- -d' ' |
  sort |
  uniq |
  while read -r path; do
    path="/${path}"
    if [ -L "${path}" ]; then
      : # The path is a symbolic link, so is probably handled by NixOS already
    elif [ -d "${path}" ]; then
      : # The path is a directory, ignore
    else
      echo "${path}"
    fi
  done

exitcode=0

# Cleanup in reverse order
readarray -t <<<"$(printf '%s\n' "${cleanup[@]}" | tac)"
for cmd in "${MAPFILE[@]}"; do
  eval "${cmd}" || exitcode=$?
done

exit "${exitcode}"
