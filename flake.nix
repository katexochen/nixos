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

    impermanence = {
      url = "github:nix-community/impermanence";
    };
  };

  outputs = { nixpkgs, ... } @ inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      inherit (nixpkgs) lib;
    in
    {
      nixosConfigurations = {
        nt14 = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/nt14/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };

        nt5 = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/nt5/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };

        nostro = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/nostro/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };

      devShells.${system} = {
        go = import ./shells/go.nix { inherit pkgs; };
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
}
