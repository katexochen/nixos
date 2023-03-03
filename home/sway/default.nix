{pkgs, ...}: {
  imports = [
    ./sway.nix

    ./mako.nix
    ./rofi.nix
    ./waybar.nix
    ./swaylock.nix
    ./swayidle.nix
  ];
}
