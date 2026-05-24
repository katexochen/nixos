{ config, lib, ... }:

{
  virtualisation.docker.enable = lib.mkIf (config.my.role == "client") true;
}
