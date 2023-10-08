{ config, lib, pkgs, ... }:
let
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
  imports = [ ./mod.nix ];

  environment.systemPackages = [
    fs-diff
    persist
  ];
}
