{ config, lib, ... }:

let
  cfg = config.my.modules.use-remote-builders;
in

{
  options.my.modules.use-remote-builders = {
    enable = lib.mkOption {
      default = false;
      description = lib.mkDoc "remote builder";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      distributedBuilds = true;
      buildMachines = [
        {
          hostName = "dell-3340-kirby";
          system = "x86_64-linux";
          protocol = "ssh-ng";
          supportedFeatures = [
            "nixos-test"
            "big-parallel"
            "kvm"
            "benchmark"
          ];
          maxJobs = 6;
          speedFactor = 6;
        }
        {
          hostName = "dell-3340-samus";
          system = "x86_64-linux";
          protocol = "ssh-ng";
          supportedFeatures = [
            "nixos-test"
            "big-parallel"
            "kvm"
            "benchmark"
          ];
          maxJobs = 6;
          speedFactor = 6;
        }
        {
          hostName = "aarch64-build-box";
          system = "aarch64-linux";
          protocol = "ssh-ng";
          supportedFeatures = [
            "nixos-test"
            "big-parallel"
            "kvm"
            "benchmark"
          ];
          maxJobs = 4;
          speedFactor = 4;
        }
        {
          hostName = "darwin-build-box";
          system = "x86_64-darwin";
          protocol = "ssh-ng";
          supportedFeatures = [
            "nixos-test"
            "big-parallel"
            "benchmark"
          ];
          maxJobs = 4;
          speedFactor = 4;
        }
      ];
    };

    programs.ssh.extraConfig = ''
      Host dell-3340-kirby
              HostName dell-3340-kirby
              ConnectTimeout 2
              IdentitiesOnly yes
              IdentityFile /root/.ssh/remote_builder
              User katexochen
      Host dell-3340-samus
              HostName dell-3340-samus
              ConnectTimeout 2
              IdentitiesOnly yes
              IdentityFile /root/.ssh/remote_builder
              User katexochen
      Host aarch64-build-box
              HostName aarch64-build-box.nix-community.org
              ConnectTimeout 2
              IdentitiesOnly yes
              IdentityFile /root/.ssh/remote_builder
              User katexochen
      Host build-box
              HostName build-box.nix-community.org
              ConnectTimeout 2
              IdentitiesOnly yes
              IdentityFile /root/.ssh/remote_builder
              User katexochen
      Host darwin-build-box
              HostName darwin-build-box.nix-community.org
              ConnectTimeout 2
              IdentitiesOnly yes
              IdentityFile /root/.ssh/remote_builder
              User katexochen
    '';
  };
}
