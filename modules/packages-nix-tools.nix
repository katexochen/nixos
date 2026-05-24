{ config, lib, pkgs, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.home.packages = with pkgs; [
      cachix
      deadnix
      nix-index
      nix-init
      nix-output-monitor
      nix-tree
      nix-update
      nixpkgs-review
      nvd
      statix
    ];
  };
}
