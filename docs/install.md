# Installation with disko

### Preparation

```sh
sudo -i
# add 'nix.settings.experimental-features = [ "nix-command" "flakes" ];'
nano /etc/nixos/configuration.nix
nixos-rebuild test
nix shell nixpkgs#git
git clone https://github.com/katexochen/nixos
cd nixos
```

### Partitioning

```sh
nix run github:nix-community/disko -- -m disko modules/disko/btrfs-luks.nix --arg disk '"/dev/nvme0n1"'
mount | grep /mnt
```

### Install

```sh
nixos-install --flake .#<host>
```

### Post-install

```sh
nixos-enter
mkdir /persist/secrets
mkpasswordfile /persist/secrets/root
mkpasswordfile /persist/secrets/katexochen
```
