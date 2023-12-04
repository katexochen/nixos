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
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , disko
    , impermanence
    , srvos
    } @ inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      authorizedKeys = {
        katexochen = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcTVEfgXMnzE6iRJM8KWsrPHCXIgxqQNMfU+RmPM25g katexochen@remoteBuilder";
      };

      inherit (nixpkgs) lib;
    in
    {
      packages.x86_64-linux = import ./packages { inherit pkgs; };

      nixosConfigurations = {
        nt14 = lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko
            ./hosts/nt14/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };

        nostro = lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko
            ./hosts/nostro/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };

        aws-builder = lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko
            # srvos.nixosModules.hardware-amazon # not compatible with disko
            srvos.nixosModules.server
            srvos.nixosModules.roles-nix-remote-builder
            ./hosts/aws-builder/configuration.nix
            {
              users.users.root.openssh.authorizedKeys.keys = lib.attrValues authorizedKeys;
              roles.nix-remote-builder.schedulerPublicKeys = lib.attrValues authorizedKeys;
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };

      devShells.${system} = {
        go = pkgs.mkShell { nativeBuildInputs = [ self.packages.x86_64-linux.go_latest ]; };
      };

      checks.${system} = {
        lint = pkgs.runCommand "lint"
          {
            nativeBuildInputs = with pkgs; [
              deadnix
              nixpkgs-fmt
              statix
            ];
          } ''
          statix check ${./.}
          deadnix --fail ${./.}
          nixpkgs-fmt --check ${./.}
          touch $out
        '';
      };

      formatter.${system} = pkgs.writeShellApplication {
        name = "normalise_nix";
        runtimeInputs = with pkgs; [
          deadnix
          nixpkgs-fmt
          statix
        ];
        text = ''
          set -x
          statix fix "$@"
          deadnix --edit "$@"
          nixpkgs-fmt "$@"
        '';
      };
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
