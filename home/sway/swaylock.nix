{pkgs, ...}: {
  programs.swaylock = {
    settings = {
      image = "/home/katexochen/nixos/wallpaper/pastel.png";
      daemonize = true;
    };
  };
}
