{ pkgs }:

pkgs.lib.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage newScope;
  directory = ./by-name;
}
