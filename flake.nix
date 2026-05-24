{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      srvos,
      treefmt-nix,
      ...
    }@inputs:
    let
      lib = import ./lib inputs;

      inherit (self) outputs;

      mkHost = lib.mkHostWith outputs;

      system = "x86_64-linux";

      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcTVEfgXMnzE6iRJM8KWsrPHCXIgxqQNMfU+RmPM25g katexochen@remoteBuilder"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAqa+JmCiwHtCNJAJ8IuHIOIMPBrjLl4vmGh86WkYs+ katexochen@np14s"
      ];

      treefmtEval = lib.eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

      nixpkgsOverlayed =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.modifications ];
          config.allowUnfree = true;
          config.nvidia.acceptLicense = true;
        };
    in
    {
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        np14s = mkHost {
          hostname = "np14s";
        };

        np14s-portable = mkHost {
          hostname = "np14s-portable";
        };

        vm-builder = mkHost {
          hostname = "vm-builder";
          withUser = false;
          extraModules = [
            srvos.nixosModules.server
            srvos.nixosModules.roles-nix-remote-builder
            {
              users.users.root.openssh.authorizedKeys.keys = authorizedKeys;
              users.users.katexochen.openssh.authorizedKeys.keys = authorizedKeys;
              roles.nix-remote-builder.schedulerPublicKeys = authorizedKeys;
            }
          ];
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

        pi = mkHost {
          hostname = "pi";
          system = "aarch64-linux";
          withUser = false;
          extraModules = [
            nixos-hardware.nixosModules.raspberry-pi-3
            {
              services.openssh.enable = true;
              users.users.root.openssh.authorizedKeys.keys = authorizedKeys;
              users.users.katexochen.openssh.authorizedKeys.keys = authorizedKeys;
            }
          ];
        };
      };

      checks = lib.eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

      formatter = lib.eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      packages = lib.eachSystem (pkgs: (lib.filterDrvs (import ./packages { inherit pkgs; })));

      legacyPackages = lib.eachSystem (
        pkgs: (import ./packages { inherit pkgs; }) // { nixpkgs = (nixpkgsOverlayed system); }
      );
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
