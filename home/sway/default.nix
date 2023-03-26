{pkgs, ...}: {
  imports = [
    ./sway.nix

    ./mako.nix
    ./rofi.nix
    ./swayidle.nix
    ./swaylock.nix
    ./waybar.nix
  ];

  home.packages = [
    pkgs.grim
    pkgs.kanshi
    pkgs.libnotify
    pkgs.pamixer
    pkgs.slurp
    pkgs.swaylock
    pkgs.wdisplays
    pkgs.wl-clipboard
    pkgs.wl-mirror
    pkgs.xdg-utils
    pkgs.xwayland
  ];
}
