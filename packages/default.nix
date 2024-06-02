{ pkgs, ... }:
with pkgs;
{
  nm-setup-rub-eduroam = callPackage ./eduroam.nix { };
  mkpasswordfile = callPackage ./mkpasswordfile.nix { };
  go_latest = callPackage ./go_latest.nix { };
  nodeshell = callPackage ./nodeshell.nix { };
}
