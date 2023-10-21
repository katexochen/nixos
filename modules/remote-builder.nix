{ config, lib, pkgs, ... }:
let
  cfg = config.my.modules.remote-bulder;
in
{
  options.my.modules.remote-bulder = {
    enable = lib.mkOption {
      default = true;
      description = lib.mkDoc "remote builder";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      distributedBuilds = true;
      settings.builders-use-substitutes = true;
      buildMachines = [
        {
          hostName = "builder";
          system = "x86_64-linux";
          protocol = "ssh-ng";
          supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
          maxJobs = 2;
          speedFactor = 2;
        }
      ];
    };

    programs.ssh.extraConfig = ''
      Host builder
              HostName 18.193.70.168
              ConnectTimeout 2
              IdentitiesOnly yes
              IdentityFile /root/.ssh/remote_builder
              User nix-remote-builder
    '';
  };
}
