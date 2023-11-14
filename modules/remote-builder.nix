{ config, lib, ... }:
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
          maxJobs = 6;
          speedFactor = 10;
        }
      ];
    };

    programs.ssh.extraConfig = ''
      Host builder
              HostName 52.28.9.128
              ConnectTimeout 2
              IdentitiesOnly yes
              IdentityFile /root/.ssh/remote_builder
              User nix-remote-builder
    '';
  };
}
