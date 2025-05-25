{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-unstable";
    };
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
    impermanence = {
      url = "github:nix-community/impermanence";
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
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues self.outputs.overlays;
      };

      nixpkgsCfg = {
        nixpkgs = {
          overlays = builtins.attrValues self.outputs.overlays;
          config.allowUnfree = true;
        };
      };

      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcTVEfgXMnzE6iRJM8KWsrPHCXIgxqQNMfU+RmPM25g katexochen@remoteBuilder"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAqa+JmCiwHtCNJAJ8IuHIOIMPBrjLl4vmGh86WkYs+ katexochen@np14s"
      ];

      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
    {
      packages.x86_64-linux = import ./packages { pkgs = nixpkgs.legacyPackages.${system}; };

      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        nt14 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixpkgsCfg
            disko.nixosModules.disko
            ./hosts/nt14/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };

        np14s = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixpkgsCfg
            disko.nixosModules.disko
            ./hosts/np14s/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };

        vm-builder = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixpkgsCfg
            disko.nixosModules.disko
            srvos.nixosModules.server
            srvos.nixosModules.roles-nix-remote-builder
            ./hosts/vm-builder/configuration.nix
            {
              users.users.root.openssh.authorizedKeys.keys = authorizedKeys;
              users.users.katexochen.openssh.authorizedKeys.keys = authorizedKeys;
              roles.nix-remote-builder.schedulerPublicKeys = authorizedKeys;
            }
          ];
          specialArgs = { inherit inputs; };
        };

        installer = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixpkgsCfg
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
            nixpkgsCfg
            ./hosts/pi/configuration.nix
            {
              services.openssh.enable = true;
              users.users.root.openssh.authorizedKeys.keys = authorizedKeys;
              users.users.katexochen.openssh.authorizedKeys.keys = authorizedKeys;
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };

      checks.${system} = {
        formatting = treefmtEval.config.build.check self;
      };

      formatter.${system} = treefmtEval.config.build.wrapper;

      legacyPackages.${system} = import ./packages { pkgs = nixpkgs.legacyPackages.${system}; };
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
