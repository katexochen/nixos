{ pgks, ... }: {
  services.mako = {
    # test with notify-send.
    enable = true;
    defaultTimeout = 4500;
    backgroundColor = "#2e3440";
    ignoreTimeout = true;
    output = "*"; # TODO: test
  };
}
