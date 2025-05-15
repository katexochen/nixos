_: {
  services.mako = {
    # test with notify-send.
    enable = true;
    settings = {
      default-timeout = 4500;
      background-color = "#2e3440";
      ignore-timeout = true;
      "mode=do-not-disturb".invisible = true;
    };
  };
}
