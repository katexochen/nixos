{ pkgs, ... }:
with pkgs;
{
  go_latest = callPackage ./go_latest.nix { };
  matrixc = callPackage ./matrixc.nix { };
  mkpasswordfile = callPackage ./mkpasswordfile.nix { };
  nm-setup-rub-eduroam = callPackage ./eduroam.nix { };
  nodeshell = callPackage ./nodeshell.nix { };
  swaylock-cmd = callPackage ./swaylock-cmd.nix { };
  swaylock-plugin = callPackage ./swaylock-plugin.nix { };
}
