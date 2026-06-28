{ config, lib, ... }:

{
  networking.networkmanager.enable = lib.mkIf (config.my.role == "client") true;
  services.resolved.enable = lib.mkDefault true;
  services.tailscale.enable = lib.mkDefault true;
}
