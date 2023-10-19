{ pkgs, ... }:
with pkgs;
{
  nm-setup-rub-eduroam = callPackage ./eduroam.nix { };
}
