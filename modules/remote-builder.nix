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
          supportedFeatures = [
            "nixos-test"
            "big-parallel"
            "kvm"
            "benchmark"
          ];
          maxJobs = 6;
          speedFactor = 12;
        }
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
          maxJobs = 3;
          speedFactor = 4;
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
          maxJobs = 3;
          speedFactor = 4;
        }
      ];
    };

    programs.ssh.extraConfig = ''
      Host builder
              HostName 34.159.30.158
              ConnectTimeout 2
              IdentitiesOnly yes
              IdentityFile /root/.ssh/remote_builder
              User katexochen
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
