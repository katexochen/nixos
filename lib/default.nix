{
  nixpkgs,
  ...
}@inputs:

let
  inherit (nixpkgs) lib;
in

{
  eachSystem = f: lib.genAttrs lib.systems.flakeExposed (system: f nixpkgs.legacyPackages.${system});

  filterDrvs = lib.filterAttrs (_name: attr: lib.isDerivation attr);

  mkHostWith =
    outputs:
    (import ./mkHost.nix { inherit inputs outputs; }).mkHost;
}
