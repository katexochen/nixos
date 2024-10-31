{ pkgs, ... }:

let
  mypkgs = import ../packages { inherit pkgs; };
in

{
  nixpkgs.overlays = [ (_final: _prev: mypkgs) ];
}
