{ config, lib, pkgs }:
let
  cfg = config.my.modules.remoteBuilders;

in
{
  options.my.modules.remoteBuilders = {
    enable = lib.mkEnableOption (lib.mkDoc "remote builders");

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
              HostName 18.224.246.43
              ConnectTimeout 2
              IdentitiesOnly yes
              IdentityFile /root/.ssh/remote_builder
              User nix-remote-builder
    '';
  };
}
