{
  nixpkgs,
  ...
}:

{
  eachSystem =
    f:
    nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: f nixpkgs.legacyPackages.${system});
}
