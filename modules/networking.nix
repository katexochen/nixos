{ config, lib, ... }:

{
  networking.networkmanager.enable = lib.mkIf (config.my.role == "client") true;
  services.resolved.enable = true;
  services.tailscale.enable = true;
}
