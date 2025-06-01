{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    srvos = {
      url = "github:numtide/srvos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      srvos,
      treefmt-nix,
      ...
    }@inputs:
    let
      lib = import ./lib inputs;

      inherit (self) outputs;

      system = "x86_64-linux";

      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcTVEfgXMnzE6iRJM8KWsrPHCXIgxqQNMfU+RmPM25g katexochen@remoteBuilder"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAqa+JmCiwHtCNJAJ8IuHIOIMPBrjLl4vmGh86WkYs+ katexochen@np14s"
      ];

      treefmtEval = lib.eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      nixosModules.common = import ./modules/common.nix;
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        np14s = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko
            ./hosts/np14s/configuration.nix
            self.outputs.nixosModules.common
          ];
          specialArgs = { inherit inputs outputs; };
        };

        vm-builder = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko
            srvos.nixosModules.server
            srvos.nixosModules.roles-nix-remote-builder
            ./hosts/vm-builder/configuration.nix
            {
              users.users.root.openssh.authorizedKeys.keys = authorizedKeys;
              users.users.katexochen.openssh.authorizedKeys.keys = authorizedKeys;
              roles.nix-remote-builder.schedulerPublicKeys = authorizedKeys;
            }
            self.outputs.nixosModules.common
          ];
          specialArgs = { inherit inputs outputs; };
        };

        installer = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
            (nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix")
            (_: {
              services.openssh.enable = true;
              users.users.root.openssh.authorizedKeys.keys = authorizedKeys;
              isoImage.squashfsCompression = "gzip -Xcompression-level 1";
            })
          ];
        };

        pi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./hosts/pi/configuration.nix
            {
              services.openssh.enable = true;
              users.users.root.openssh.authorizedKeys.keys = authorizedKeys;
              users.users.katexochen.openssh.authorizedKeys.keys = authorizedKeys;
            }
            self.outputs.nixosModules.common
          ];
          specialArgs = { inherit inputs outputs; };
        };
      };

      checks = lib.eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

      formatter = lib.eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      packages = lib.eachSystem (pkgs: import ./packages { inherit pkgs; });

      legacyPackages = lib.eachSystem (pkgs: import ./packages { inherit pkgs; });
    };

  nixConfig = {
    extra-substituters = [
      "https://katexochen.cachix.org"
    ];
    extra-trusted-public-keys = [
      "katexochen.cachix.org-1:ScfG6cUxfuZxn3n43fYVqK3ha2TMPLG7kJ52s6PKHqo="
    ];
  };
}
