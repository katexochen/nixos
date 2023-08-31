{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./starship.nix
    ./alacritty.nix
  ];
}
