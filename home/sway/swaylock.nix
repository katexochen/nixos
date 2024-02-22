_: {
  programs.swaylock = {
    settings = {
      image = "${../../wallpaper/pastel.png}";
      daemonize = true;
      ignore-empty-password = true;
    };
  };
}
