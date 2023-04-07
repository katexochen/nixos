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
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    inherit (self) outputs;

    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      nt14 = lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nt14/configuration.nix
        ];
        specialArgs = {inherit inputs outputs;};
      };

      nt5 = lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nt5/configuration.nix
        ];
        specialArgs = {inherit inputs outputs;};
      };
      nostro = lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nostro/configuration.nix
        ];
        specialArgs = {inherit inputs outputs;};
      };
    };
  };
}
