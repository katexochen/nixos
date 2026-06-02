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
          hostName = "pylos";
          system = "x86_64-linux";
          protocol = "ssh-ng";
          sshUser = "nix-remote-builder";
          sshKey = "/root/.ssh/remote_builder";
          publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUh4K2Q3Q2NTbzJOeHdEbVkwRnk1Ym1GTDVnYjIvWHhWOG5SSDZEa2JqdUYK";
          supportedFeatures = [
            "nixos-test"
            "big-parallel"
            "kvm"
            "benchmark"
          ];
          maxJobs = 8;
          speedFactor = 10;
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

    networking.hosts."142.132.219.56" = [ "pylos" ];

    programs.ssh.extraConfig = ''
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
