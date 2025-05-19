{ pkgs }:

# pkgs.lib.packagesFromDirectoryRecursive {
#   inherit (pkgs) callPackage;
#   directory = ./by-name;
# }

{
  matrixc = pkgs.callPackage ./by-name/matrixc.nix { };
  swaylock-cmd = pkgs.callPackage ./by-name/swaylock-cmd.nix { };
  mkpasswordfile = pkgs.callPackage ./by-name/mkpasswordfile.nix { };
  nodeshell = pkgs.callPackage ./by-name/nodeshell.nix { };
  nm-setup-rub-eduroam = pkgs.callPackage ./by-name/nm-setup-rub-eduroam.nix { };
}
