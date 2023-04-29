{pkgs, ...}: {
  imports = [
    ./sway.nix

    ./mako.nix
    ./rofi.nix
    ./swayidle.nix
    ./swaylock.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    grim
    kanshi
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
