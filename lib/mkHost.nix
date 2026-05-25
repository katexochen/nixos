{ inputs, outputs }:

{
  mkHost =
    {
      hostname,
      system ? "x86_64-linux",
      withUser ? true,
      extraModules ? [ ],
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager
        ../hosts/${hostname}.nix
        ../modules
      ]
      ++ inputs.nixpkgs.lib.optionals withUser [
        ../users/katexochen
      ]
      ++ extraModules;
      specialArgs = { inherit inputs outputs; };
    };
}
