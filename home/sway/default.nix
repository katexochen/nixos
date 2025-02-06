{ pkgs, ... }:
{
  imports = [
    ./sway.nix

    ./mako.nix
    ./rofi.nix
    ./swayidle.nix
    ./swaylock.nix
    ./waybar.nix
    ./kanshi.nix
  ];

  home.packages = with pkgs; [
    grim
    libnotify
    pamixer
    slurp
    swayimg
    wdisplays
    wl-clipboard
    wl-mirror
    xdg-utils
    xwayland
  ];
}
