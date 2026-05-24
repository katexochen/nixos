{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (config.my.role == "client") {
    services.power-profiles-daemon.enable = true;
    environment.systemPackages = [ pkgs.toggle-power-profile ];
  };
}
